// Server
const express = require('express');
const app = express(); 
const server = require('http').createServer(app);
const io = require('./io')(server);
const PORT = 3000;

// Session Connect
const session = require('./server/config/session');
app.use(session);

// Setting
app.use(express.static('view')); // 정적 파일 경로 설정
app.use(express.urlencoded({extended: false})); // query-string
app.set('io', io); // 외부 파일에서의 사용을 위한 io 전역 변수 등록

// Login Page Router
const loginRouter = require('./server/src/loginRouter');
app.use('/login', loginRouter);

// Lists Page Router (FriendsList, ChatsList, Setting)
const listsRouter = require('./server/src/listsRouter');
app.use('/lists', listsRouter);

// Server Listening
server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});