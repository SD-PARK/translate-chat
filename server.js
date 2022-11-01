const express = require('express');
const app = express(); 
const server = require('http').createServer(app);
const session = require('express-session');
const MemoryStore = require('memorystore')(session);

const PORT = 3000;

app.use(express.static('view')); // root 지정
app.use(express.urlencoded({extended: false})); // query-string
const sessionObj = {
    //httpOnly: true, // true라면 js로 쿠키 조회 불가
    //secure: true, // https 환경에서만 session 정보를 주고 받음.
    secret: '@translate-chat', // cookie의 임의 변경을 방지, 이 값을 토대로 session을 암호화하여 저장
    resave: false, // session에 변경사항이 없을 때 저장 여부
    saveUninitialized: true, // session이 최초 생성 뒤 수정이 안 된다면, 저장되기 전 uninitialized 상태로 미리 만들어 저장한다. 일반적으로 false.
    store: new MemoryStore({ checkPeriod: 1000 * 60 * 10 }),
    cookie: {
        maxAge: 1000 * 60 * 10,
    },
};

app.use(session(sessionObj));

const loginRouter = require('./server/loginRouter');
app.use('/login', loginRouter);

server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});