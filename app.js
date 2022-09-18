const app = require('express')();
const server = require('http').createServer(app);
const io = require('socket.io')(server);

// 포트 값 지정; localhost:{PORT}
const PORT = 3000;

// Default(localhost:{PORT}) 주소로 접근 시 index 전송
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

io.on('connection', (socket) => {
    // 접속 시 소켓 데이터 저장
    socket.on('login', (data) => {
        console.log('Client logged-in:\n Name: ' + data.name + '\n Userid: ' + data.userid);
        socket.name = data.name;
        socket.userid = data.userid;
    });

    // 채팅 입력 시 같은 룸의 모든 클라이언트에게 입력받은 채팅, 메세지, 시간 전송
    socket.on('chat', (msg) => {
        console.log('Room ' + socket.room + ';' + socket.name + ': ' + msg);
        io.to(socket.room).emit('chat', {
            name: socket.name,
            msg: msg,
            time: timePrint()
        });
    });

    // 방 입장 시 해당 룸에 접속 알림 메시지 전송
    socket.on('joinRoom', (roomNum) => {
        if(socket.room != undefined)
            socket.leave(socket.room);
        socket.room = roomNum;

        console.log('Client joined :\n Name: ' + socket.name + '\n Room: ' + socket.room);
        socket.join(socket.room);

        io.to(socket.room).emit('joinRoom', socket.name);
    });

    /** 현재 시간 값 */
    function timePrint() {
        let time = new Date();
        let hours = ('0' + time.getHours()).slice(-2);
        let minutes = ('0' + time.getMinutes()).slice(-2);
        let seconds = ('0' + time.getSeconds()).slice(-2);

        return hours + ':' + minutes + ':' + seconds;
    }
});

// 지정된 포트{PORT}로 서버 실행
server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});