const app = require('express')();
const server = require('http').createServer(app);
const io = require('socket.io')(server);

// 포트 값 지정; localhost:{PORT}
const PORT = 3000;

// Default(localhost:{PORT}) 주소로 접근 시
app.get('/', (req, res) => {
    res.sendFile(__dirname, '/index.html');
});

io.on('connection', (socket) => {
    
});

// 서버 실행 시
server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});