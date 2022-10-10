const app = require('express')();
const server = require('http').createServer(app);
const io = require('socket.io')(server);

const papago = require('./translate');
const db = require('./config/dbConn');

// 포트 값 지정; localhost:{PORT}
const PORT = 3000;

// Default(localhost:{PORT}) 주소로 접근 시 index 전송
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

app.get('/db', async (req, res) => {
    const conn = await db.getConnection();
    const rows = await conn.query('SELECT * FROM users'); // 쿼리 실행
    res.send(rows[0]);
})

io.on('connection', (socket) => {
    // 접속 시 소켓 데이터 저장
    socket.on('login', (data) => {
        console.log('Client logged-in:\n Name: ' + data.name + '\n Languege: ' + data.languege);
        socket.name = data.name;
        socket.userid = data.userid;
        socket.languege = data.languege;
    });

    // 채팅 입력 시 같은 룸의 모든 클라이언트에게 입력받은 채팅, 메세지, 시간, 언어 전송
    socket.on('chat', (msg) => {
        console.log('(Room ' + socket.room + ') ' + socket.name + ': ' + msg);
        let config = {
            name: socket.name,
            msg: msg,
            time: timePrint(),
            lang : socket.languege
        };
        io.to(socket.room).emit('chat', config);
    });

    // 전송받은 메세지를 번역 후 callback.
    socket.on('translate', async (data, callback) => {
        let trans_msg;
        try {
            trans_msg = await papago.lookup(data.source, socket.languege, data.msg);
            console.log('Translate Complete: ', data.msg, ' -> ', trans_msg);
        } catch(e) {
            trans_msg = data.msg;
            console.log('Translate Failed: ', data.msg);
        }
        callback({
            msg: trans_msg
        });
    });

    // 방 입장 시 해당 룸에 접속 알림 메시지 전송
    socket.on('joinRoom', (roomNum) => {
        if(socket.room != undefined) {
            socket.leave(socket.room);
            io.to(socket.room).emit('leftRoom', socket.name);
        }
        socket.room = roomNum;

        console.log('Room joined :\n Name: ' + socket.name + '\n Room: ' + socket.room);
        socket.join(socket.room);

        io.to(socket.room).emit('joinRoom', socket.name);
    });

    // 사용 언어 변경
    socket.on('setLanguege', (lang) => {
        socket.languege = lang;
        console.log('Change Languege :\n Name: ' + socket.name + '\n Languege: ' + socket.languege);
    });

    /** 현재 시간 값 {am/pm hh:mm} */
    function timePrint() {
        return new Intl.DateTimeFormat('ko', {timeStyle: 'short'}).format(new Date());
    }
});

// 지정된 포트{PORT}로 서버 실행
server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});