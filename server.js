const express = require('express');
const app = express(); 
const server = require('http').createServer(app);

const PORT = 3000;

app.use(express.static('public')); // root 지정
app.use(express.urlencoded({extended: false})); // query-string

// testing...
const nunjucks = require('nunjucks');
nunjucks.configure('views', {express: app}); // views 폴더가 넌적스 파일의 위치가 됨, express 속성에 app 객체(express();) 연결
// db 대용
const user = {
    email: '1812105@du.ac.kr',
    password: '1812105',
    name : '박상도'
};

// login
app.get('/login', (req, res) => {
    res.sendFile(__dirname + '/public/html/login.html');
    res.setHeader('Set-Cookie', '')
});

app.post('/login', (req, res) => {
    const {email, password} = req.body;
    
    if(email === user.email && password === user.password)
        res.setHeader('Set-Cookie', 'login=true');
    else
        res.setHeader('Set-Cookie', 'login=false');

    res.redirect('/login');
});

server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});