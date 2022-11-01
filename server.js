const express = require('express');
const app = express(); 
const server = require('http').createServer(app);
const nunjucks = require('nunjucks');

const PORT = 3000;

app.use(express.static('public')); // root 지정
app.use(express.urlencoded({extended: false})); // query-string

// testing...
nunjucks.configure('views', {express: app}); // views 폴더가 넌적스 파일의 위치가 됨, express 속성에 app 객체(express();) 연결

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/html/cookie-test.html');
    res.setHeader('Set-Cookie', 'test=1');
});

// login
app.get('/login', (req, res) => {
    res.sendFile(__dirname + '/public/html/login.html');
});

server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});