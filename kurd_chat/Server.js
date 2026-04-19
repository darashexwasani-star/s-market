const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);
const multer = require('multer');
const Datastore = require('nedb');

const db = new Datastore({ filename: './users.db', autoload: true });
app.use(express.urlencoded({ extended: true }));
app.use('/uploads', express.static('uploads'));

const upload = multer({ dest: 'uploads/' });

app.get('/', (req, res) => res.sendFile(__dirname + '/index.html'));

// دروستکردنی ئەکاونت بە سادەیی
app.post('/signup', upload.single('avatar'), (req, res) => {
    const { username, password } = req.body;
    const imgPath = req.file ? '/uploads/' + req.file.filename : '/uploads/default.png';
    
    db.insert({ user: username, pass: password, img: imgPath }, (err) => {
        if (err) return res.send("کێشەیەک هەیە");
        res.send("<h1>ئەکاونت دروستکرا!</h1><a href='/'>بگەڕێوە و لۆگین بکە</a>");
    });
});

io.on('connection', (socket) => {
    socket.on('join', (data) => {
        db.findOne({ user: data.name }, (err, user) => {
            if (user) {
                socket.user = user;
                socket.emit('auth-success', user);
            } else {
                socket.emit('auth-error', 'ئەم ناوە نییە، سەرەتا ئەکاونت دروست بکە');
            }
        });
    });
    socket.on('chat message', (msg) => {
        if(socket.user) io.emit('chat message', { text: msg, user: socket.user.user, img: socket.user.img });
    });
});

http.listen(5050, () => console.log('سێرڤەر ئامادەیە لە پۆڕتی 5050'));
