const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);

app.use(express.static(__dirname));

io.on('connection', (socket) => {
    socket.on('join', (username) => {
        socket.broadcast.emit('chat-msg', { name: 'System', text: `سەرچاوم هاتی ${username} گیان 🌹`, isSystem: true });
    });
    socket.on('sync-video', (data) => { socket.broadcast.emit('sync-video', data); });
    socket.on('chat-msg', (data) => { io.emit('chat-msg', data); });
});

http.listen(7070, () => { console.log('سێرڤەری پڕۆفیشناڵ ئامادەیە لەسەر 7070'); });

