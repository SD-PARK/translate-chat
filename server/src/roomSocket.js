module.exports = (io, db) => {
    const Room = io.of('/room');
    const papago = require('../src/translate');

    /** NULL인 각 언어 메세지 번역 처리 */
    const nullIsTranslate = (room_id, userLanguage) => {
        return new Promise((resolve, reject) => {
            console.log('func: nullIsTranslate');
            db.query(`CALL GET_NULLTEXT(${room_id}, '${userLanguage}');`, async (err, nullList) => { if (err) return console.log(err);
                const len = nullList[0].length;
                for(let i=0; i<len; i++) {
                    console.log(nullList[0][i].FROM_LANGUAGE, userLanguage, nullList[0][i].ORIGINAL_MSG);
                    let transMsg = await papago.lookup(nullList[0][i].FROM_LANGUAGE, userLanguage, nullList[0][i].ORIGINAL_MSG);
                    db.query(`CALL UPDATE_TRANSLATION(${room_id}, ${nullList[0][i].MSG_NUM}, '${userLanguage}', '${transMsg}');`, (err, res) => { if (err) return console.log(err); });
                }
                resolve();
            });
        });
    }
    
    Room.on('connection', (socket) => {
        console.log('Socket.io [Room] Namespace Connected');

        socket.on('join', (data, callback) => {
            socket.user_id = data.user_id;
            socket.room_id = data.room_id;

            socket.join(data.room_id);
            console.log('[Room: ' + data.room_id + '] join, ', socket.user_id, socket.room_id);

            db.query(`SELECT users.LANGUAGE, info.ROOM_NAME FROM room_info AS info, users
                    WHERE info.USER_ID = ${socket.user_id} AND info.ROOM_ID = ${socket.room_id} AND info.USER_ID = users.ID`, async (err, userCheck) => { if (err) return console.log(err);
                if (userCheck[0]) { // room에 속한 user일 때.
                    console.log('userCheck = ', userCheck[0].LANGUAGE);
                    socket.language = userCheck[0].LANGUAGE;
                    
                    const title = userCheck[0].ROOM_NAME;

                    console.log(await nullIsTranslate(socket.room_id, socket.language), '\n\n\n\n\n');
                    db.query(`SELECT msg.MSG_NUM, msg.SEND_USER_ID, IFNULL(users.IMG_URL, "default_profile.png") AS IMG_URL, msg.ORIGINAL_MSG, msg.TO_${socket.language} AS MSG, msg.SEND_TIME
                                    FROM users RIGHT OUTER JOIN room_message_${socket.room_id} AS msg
                                    ON users.ID = msg.SEND_USER_ID`, (err, msgResult) => { if (err) return console.log(err);
                                        callback(title, msgResult);
                    });
                } else {
                    callback('No permissions');
                }
            });
        });

        socket.on('sendMsg', (msg) => {
            console.log('socket: sendMsg');
            // DB에 메세지 저장 후 마지막 메세지의 MSG_NUM 가져옴.
            db.query(`CALL SEND_MESSAGE(${socket.room_id}, ${socket.user_id}, '${msg}');`, (err, msgNum) => { if (err) return console.log(err);
                console.log(msgNum[0][0].MSG_NUM);
                Room.to(socket.room_id).emit('tellNewMsg', msgNum[0][0].MSG_NUM); // Room에 접속한 Socket에게 MSG_NUM과 함께 전송
                console.log('socket: sendMsg -> tellNewMsg', msgNum[0][0].MSG_NUM);
            });
        });

        socket.on('callNewMsg', async (msg_num, callback) => {
            console.log('socket: callNewMsg');
            console.log(await nullIsTranslate(socket.room_id, socket.language), '\n\n\n\n\n');
            setTimeout(() => {
                db.query(`SELECT msg.MSG_NUM, msg.SEND_USER_ID, IFNULL(users.IMG_URL, "default_profile.png") AS IMG_URL, msg.ORIGINAL_MSG, msg.TO_${socket.language} AS MSG, msg.SEND_TIME
                FROM users RIGHT OUTER JOIN room_message_${socket.room_id} AS msg
                ON users.ID = msg.SEND_USER_ID
                WHERE msg.MSG_NUM = ${msg_num}`, (err, msg) => { if (err) return console.log(err);
                    console.log(msg_num, msg[0]);
                    callback(msg[0]);
                });
            }, 2);
        });
        
        socket.on('roomTitleChange', (room_name) => {
            db.query(`UPDATE room_info SET ROOM_NAME = '${room_name}' WHERE ROOM_ID = ${socket.room_id} AND USER_ID = ${socket.user_id};`, (err, res) => { if (err) return console.log(err); });
        });

        socket.on('disconnect', () => {
            console.log('[Room] Namespace Disconnected');
        });
    });

    return Room;
}