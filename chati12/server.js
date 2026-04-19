const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const fs = require('fs');

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

const DB_PATH = './database.json';
let db = fs.existsSync(DB_PATH) ? JSON.parse(fs.readFileSync(DB_PATH)) : { users: {} };

const saveDB = () => fs.writeFileSync(DB_PATH, JSON.stringify(db, null, 4));

app.use(express.static('public'));

io.on('connection', (socket) => {
    socket.on('auth', ({ u, p, type }) => {
        if (type === 'reg') {
            if (db.users[u]) return socket.emit('msg', 'ئەم ناوە هەیە');
            db.users[u] = { p, friends: [], reqs: [], msgs: {} };
        } else {
            if (!db.users[u] || db.users[u].p !== p) return socket.emit('msg', 'زانیاری هەڵەیە');
        }
        socket.un = u; db.users[u].sid = socket.id;
        saveDB(); socket.emit('auth_ok', { u, friends: db.users[u].friends, reqs: db.users[u].reqs });
    });

    socket.on('add_friend', (to) => {
        if (db.users[to] && to !== socket.un && !db.users[to].reqs.includes(socket.un)) {
            db.users[to].reqs.push(socket.un); saveDB();
            io.to(db.users[to].sid).emit('new_req', socket.un);
        }
    });

    socket.on('accept', (from) => {
        const me = socket.un;
        db.users[me].friends.push(from); db.users[from].friends.push(me);
        db.users[me].reqs = db.users[me].reqs.filter(r => r !== from);
        saveDB(); socket.emit('update'); io.to(db.users[from].sid).emit('update');
    });

    socket.on('p_msg', ({ to, txt }) => {
        const msgObj = { f: socket.un, t: txt, d: new Date().getTime() };
        if (!db.users[socket.un].msgs[to]) db.users[socket.un].msgs[to] = [];
        if (!db.users[to].msgs[socket.un]) db.users[to].msgs[socket.un] = [];
        db.users[socket.un].msgs[to].push(msgObj); db.users[to].msgs[socket.un].push(msgObj);
        saveDB();
        io.to(db.users[to].sid).emit('rx_msg', msgObj); socket.emit('rx_msg', msgObj);
    });

    socket.on('get_chat', (fr) => {
        socket.emit('chat_history', db.users[socket.un].msgs[fr] || []);
    });
});

server.listen(3939, () => console.log('💎 Enterprise Server Active on 3939'));
