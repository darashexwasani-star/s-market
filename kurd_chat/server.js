const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);
const multer = require('multer');
const Datastore = require('nedb');
const path = require('path');
const fs = require('fs');

if (!fs.existsSync('./uploads')) fs.mkdirSync('./uploads');

const db = new Datastore({ filename: './users.db', autoload: true });
const msgDb = new Datastore({ filename: './messages.db', autoload: true });

app.use(express.json());
app.use('/uploads', express.static('uploads'));
app.use(express.static('./'));

const storage = multer.diskStorage({
    destination: 'uploads/',
    filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname))
});
const upload = multer({ storage: storage });

// سیستەمی چوونەژوورەوەی سناپ
app.post('/auth', upload.single('avatar'), (req, res) => {
    const { username, password } = req.body;
    db.findOne({ username }, (err, user) => {
        if (user) {
            if (user.password === password) return res.json(user);
            else return res.status(401).json({ error: "پاسۆرد هەڵەیە" });
        }
        const newUser = {
            username, password,
            avatar: req.file ? '/uploads/' + req.file.filename : 'https://ui-avatars.com/api/?name='+username
        };
        db.insert(newUser, (err, doc) => res.json(doc));
    });
});

app.get('/search', (req, res) => {
    db.find({}, (err, docs) => res.json(docs));
});

io.on('connection', (socket) => {
    socket.on('join', (user) => { socket.join(user.username); socket.user = user; });
    socket.on('private-msg', (data) => {
        const msg = { from: socket.user.username, to: data.to, text: data.text, time: new Date() };
        msgDb.insert(msg, (err, doc) => {
            io.to(data.to).to(socket.user.username).emit('new-msg', doc);
        });
    });
});

http.listen(5050, '0.0.0.0', () => console.log('Snap System Ready: 5050'));
