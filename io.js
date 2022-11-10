module.exports = (server) => {
    const db = require('./server/config/db');
    const io = require('socket.io')(server, {path: '/socket.io'});
    const papago = require('./server/src/translate');
    
    // Namespace
    const friendsList = io.of('/friendsList');
    const RoomList = io.of('/roomsList');
    const Room = io.of('/room');
    
    friendsList.on('connection', (socket) => {
        console.log('Socket.io [friendsList] Namespace Connected');

        // FriendsList 로드 시 쿠키 값(user_id) 받아와 친구 목록 조회하고 callback.
        socket.on('view', (user_id, callback) => {
            db.query(`SELECT ID, NAME, EMAIL, IMG_URL FROM users WHERE ID=${user_id}`, (err, user_result) => {
                if (err) return console.log(err);

                db.query(`SELECT users.ID, users.NAME, users.EMAIL, users.IMG_URL
                    FROM users, relations
                    WHERE relations.USER_ID=${user_id} AND users.ID = relations.TARGET_ID AND relations.RELATION_TYPE = "FRIEND"`, (err, friends_result) => {
                    if (err) return console.log(err);
                    
                    callback({user_result: user_result[0], friends_result: friends_result});
                });
            });
        });
    
        socket.on('disconnect', () => {
            console.log('[friendsList] Namespace Disconnected');
        });
    });

    RoomList.on('connection', (socket) => {
        console.log('Socket.io [RoomList] Namespace Connected');

        socket.on('view', (user_id, callback) => {
            // ROOM_ID, ROOM_NAME, SEND_TIME, MSG
            db.query(`SELECT info.ROOM_ID, info.ROOM_NAME, msg.SEND_TIME, msg.ORIGINAL_MSG AS MSG FROM room_info AS info,
                    (SELECT * FROM room_message_1 ORDER BY SEND_TIME DESC LIMIT 1) AS msg WHERE USER_ID = ${user_id} AND FAVORITES = 1`, (err, favorites_result) => { if (err) return console.log(err);

                        db.query(`SELECT info.ROOM_ID, info.ROOM_NAME, msg.SEND_TIME, msg.ORIGINAL_MSG AS MSG FROM room_info AS info,
                                (SELECT * FROM room_message_1 ORDER BY SEND_TIME DESC LIMIT 1) AS msg WHERE USER_ID = ${user_id} AND FAVORITES = 0`, (err, normal_result) => { if (err) return console.log(err);
                                    callback({favorites_result, normal_result});
                        });
                    });
        });

        socket.on('disconnect', () => {
            console.log('[roomsList] Namespace Disconnected');
        });
    })

    Room.on('connection', (socket) => {
        console.log('Socket.io [Room] Namespace Connected');

        socket.on('join', (data, callback) => {
            socket.join(data.room_id);
            console.log('[Room: ' + data.room_id + '] join');

            db.query(`SELECT * FROM room_info WHERE USER_ID = ${data.user_id} AND ROOM_ID = ${data.room_id}`, (err, belong) => { if (err) return console.log(err);
                if (belong) { // room에 속한 user일 때.
                    db.query(`SELECT LANGUAGE FROM users WHERE ID = ${data.user_id}`, (err, lang) => { if (err) return console.log(err); // 유저 언어 값
                        const user_language = lang[0].LANGUAGE;
                        
                        nullIsTranslate(data.room_id, user_language);

                        db.query(`SELECT msg.SEND_USER_ID, users.IMG_URL, msg.TO_${user_language} AS MSG, msg.SEND_TIME
                                FROM users RIGHT OUTER JOIN room_message_${data.room_id} AS msg
                                ON users.ID = msg.SEND_USER_ID;`, (err, msgResult) => { if (err) return console.log(err);
                                    callback(msgResult);
                                });
                    });
                } else {
                    callback('No permissions');
                }
            });
        });

        socket.on('sendMsg', (data) => {
            // data.user_id, room_id, msg
            console.log('sendMsg');
            // 메세지 DB 저장, READ_COUNT 제거할 것.
            db.query(`INSERT INTO room_message_${data.room_id} (SEND_USER_ID, ORIGINAL_MSG, READ_COUNT, FROM_LANGUAGE)
                    SELECT ${data.user_id}, "${data.msg}", 0, LANGUAGE
                    FROM users WHERE id = ${data.user_id};`, (err, result) => { if (err) return console.log(err); });

            // Room에 접속한 Socket에게 전송
            Room.to(data.room_id).emit('tellNewMsg');
        });

        socket.on('callNewMsg', (data, callback) => {
            
        });

        function nullIsTranslate(room_id, user_language) {
            db.query(`SELECT MSG_NUM, ORIGINAL_MSG, FROM_LANGUAGE FROM room_message_${room_id} WHERE TO_${user_language} IS NULL`, (err, nullMsg) => { if (err) return console.log(err);
                for(let i=nullMsg.length-1; i>=0; i--) {
                    let transMsg = papago.lookup(nullMsg.FROM_LANGUAGE, user_language, nullMsg.ORIGINAL_MSG)
                    db.query(`UPDATE room_message_${room_id} SET TO_${user_language} = ${transMsg} WHERE MSG_NUM = ${nullMsg.MSG_NUM};`, (err, res) => { if (err) return console.log(err); });
                }
            });
        }
        
        socket.on('disconnect', () => {
            console.log('[Room] Namespace Disconnected');
        });
    });

    return io;
}