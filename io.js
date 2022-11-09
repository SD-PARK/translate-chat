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

        socket.on('join', (user_id, room_id, callback) => {

            db.query(`SELECT * FROM room_info WHERE USER_ID = ${user_id} AND ROOM_ID = ${room_id}`, (err, belong) => { if (err) return console.log(err);
                if (belong) { // room에 속한 user일 때.
                    db.query(`SELECT LANGUAGE FROM users WHERE ID = ${user_id}`, (err, lang) => { if (err) return console.log(err); // 유저 언어 값
                        const user_language = lang[0].LANGUAGE;
                        db.query(`SELECT room.MSG_NUM, room.SEND_USER_ID, users.IMG_URL, room.TO_${user_language} AS MSG, room.FROM_LANGUAGE, room.SEND_TIME
                                FROM users RIGHT OUTER JOIN room_message_${room_id} AS room
                                ON room.SEND_USER_ID = users.ID`, (err, msg_result) => { if (err) return console.log(err); // room의 메세지 가져옴

                            for(let i = msg_result.length - 1; i>=0; i--) { // 가져온 메세지의 NULL 값 체크
                                if (msg_result[i].MSG == undefined) { // 비어있으면 번역
                                    db.query(`SELECT ORIGINAL_MSG FROM room_message_${room_id} WHERE MSG_NUM = ${msg_result[i].MSG_NUM}`, (err, msg) => { if (err) return console.log(err);
                                        
                                        let trans_msg = papago.lookup(msg_result[i].FROM_LANGUAGE, user_language, msg[0].ORIGINAL_MSG);
                                        db.query(`UPDATE room_message_${room_id} SET TO_${user_language} = "${trans_msg}" WHERE MSG_NUM = ${msg_result[i].MSG_NUM}`, (err, result) => { if (err) return console.log(err); });
                                        msg_result[i].MSG = trans_msg;
                                    })
                                }
                            }
                            console.log(msg_result);
                            callback(msg_result);
                        });
                    });
                } else {
                    // callback();
                }
            });
        });
        
        socket.on('disconnect', () => {
            console.log('[Room] Namespace Disconnected');
        });
    });

    return io;
}