module.exports = (io, db) => {
    const Room = io.of('/room');
    const papago = require('../src/translate');
    
    Room.on('connection', (socket) => {
        console.log('Socket.io [Room] Namespace Connected');

        socket.on('join', (data, callback) => {
            socket.join(data.room_id);
            console.log('[Room: ' + data.room_id + '] join');

            db.query(`SELECT users.LANGUAGE FROM room_info AS info, users
                    WHERE info.USER_ID = ${data.user_id} AND info.ROOM_ID = ${data.room_id} AND info.USER_ID = users.ID`, (err, userLanguage) => { if (err) return console.log(err);
                if (userLanguage) { // room에 속한 user일 때.
                    console.log('userLanguage = ', userLanguage);
                    
                    nullIsTranslate(data.room_id, userLanguage[0].LANGUAGE);
        
                    db.query(`SELECT msg.SEND_USER_ID, users.IMG_URL, msg.TO_${userLanguage[0].LANGUAGE} AS MSG, msg.SEND_TIME
                            FROM users RIGHT OUTER JOIN room_message_${data.room_id} AS msg
                            ON users.ID = msg.SEND_USER_ID`, (err, msgResult) => { if (err) return console.log(err);
                                callback(msgResult);
                            });
                } else {
                    callback('No permissions');
                }
            });
        });

        socket.on('sendMsg', (data) => {
            console.log('socket: sendMsg');
            // DB에 메세지 저장
            db.query(`INSERT INTO room_message_${data.room_id} (SEND_USER_ID, ORIGINAL_MSG, FROM_LANGUAGE)
                    SELECT ${data.user_id}, "${data.msg}", LANGUAGE
                    FROM users WHERE id = ${data.user_id};`, (err, result) => { if (err) return console.log(err); });

            db.query(`SELECT MSG_NUM FROM room_message_${data.room_id} ORDER BY MSG_NUM DESC LIMIT 1`, (err, num) => { if (err) return console.log(err);
                Room.to(data.room_id).emit('tellNewMsg', num[0].MSG_NUM); // Room에 접속한 Socket에게 MSG_NUM과 함께 전송
            });
        });

        socket.on('callNewMsg', (data, callback) => {
            console.log('socket: callNewMsg');

            db.query(`SELECT LANGUAGE FROM users WHERE ID = ${data.user_id}`, (err, userLanguage) => { if (err) return console.log(err);
                nullIsTranslate(data.room_id, userLanguage[0].LANGUAGE);
                setTimeout(() => {
                    db.query(`SELECT msg.SEND_USER_ID, users.IMG_URL, msg.TO_${userLanguage[0].LANGUAGE} AS MSG, msg.SEND_TIME
                    FROM users RIGHT OUTER JOIN room_message_${data.room_id} AS msg
                    ON users.ID = msg.SEND_USER_ID
                    WHERE msg.MSG_NUM = ${data.MSG_NUM}`, (err, msg) => { if (err) return console.log(err);
                        callback(msg);
                    });
                }, 100);
            });

        });

        /** NULL인 각 언어 메세지 번역 처리 */
        function nullIsTranslate(room_id, userLanguage) {
            console.log('func: nullIsTranslate');
            db.query(`SELECT MSG_NUM, ORIGINAL_MSG, FROM_LANGUAGE FROM room_message_${room_id} WHERE TO_${userLanguage} IS NULL`, (err, nullMsg) => { if (err) return console.log(err);
                for(let i=nullMsg.length-1; i>=0; i--) {
                    let transMsg = papago.lookup(nullMsg[0].FROM_LANGUAGE, userLanguage, nullMsg[0].ORIGINAL_MSG)
                    db.query(`UPDATE room_message_${room_id} SET TO_${userLanguage} = "${transMsg}" WHERE MSG_NUM = ${nullMsg[0].MSG_NUM};`, (err, res) => { if (err) return console.log(err); });
                }
            });
        }
        
        socket.on('disconnect', () => {
            console.log('[Room] Namespace Disconnected');
        });
    });

    return Room;
}