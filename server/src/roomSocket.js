module.exports = (io, db) => {
    const Room = io.of('/room');
    const papago = require('../src/translate');
    const escapeMap = require('../config/escapeMap');

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

            db.query(`CALL GET_PERMISSION_CHECK(${socket.room_id}, ${socket.user_id});`, async (err, info) => { if (err) return console.log(err); // 방 접근 권한 체크 후 언어, 타이틀 값 리턴.
                if (info[0][0]) { // room에 속한 user일 때.
                    console.log('info[0] = ', info[0][0].LANGUAGE);
                    socket.language = info[0][0].LANGUAGE;
                    const roomId = socket.room_id;                    
                    const title = info[0][0].ROOM_NAME;

                    console.log(await nullIsTranslate(socket.room_id, socket.language), '\n\n\n\n\n');
                    db.query(`CALL VIEW_ALL_MESSAGES(${roomId}, '${socket.language}');`, (err, msgResult) => { if (err) return console.log(err);
                        callback(title, msgResult[0]);
                    });
                } else {
                    callback('No permissions');
                }
            });
        });

        socket.on('sendMsg', (msg) => {
            console.log('socket: sendMsg');
            // DB에 메세지 저장 후 마지막 메세지의 MSG_NUM 가져옴.
            const eMsg = escapeMap(msg); // 이스케이프 문자 처리
            db.query(`CALL UPDATE_SEND_MESSAGE(${socket.room_id}, ${socket.user_id}, "${eMsg}");`, (err, msgNum) => { if (err) return console.log(err);
                console.log(msgNum[0][0].MSG_NUM);
                Room.to(socket.room_id).emit('tellNewMsg', msgNum[0][0].MSG_NUM); // Room에 접속한 Socket에게 MSG_NUM과 함께 전송
                console.log('socket: sendMsg -> tellNewMsg', msgNum[0][0].MSG_NUM);
            });
        });

        socket.on('callNewMsg', async (msg_num, callback) => {
            console.log('socket: callNewMsg');
            console.log(await nullIsTranslate(socket.room_id, socket.language), '\n\n\n\n\n');
            setTimeout(() => {
                db.query(`CALL VIEW_SINGLE_MESSAGE(${socket.room_id}, '${socket.language}', ${msg_num});`, (err, msg) => { if (err) return console.log(err);
                    console.log(msg_num, msg[0][0]);
                    callback(msg[0][0]);
                });
            }, 2);
        });
        
        socket.on('roomTitleChange', (room_name) => {
            const eRoom_name = room_name;
            db.query(`CALL UPDATE_ROOM_TITLE(${socket.room_id}, ${socket.user_id}, '${eRoom_name}');`, (err, res) => { if (err) return console.log(err); });
        });

        socket.on('friendsSearch', (factor, callback) => {
            const roomId = socket.room_id;
            const userId = socket.user_id;
            const eFactor = escapeMap(factor);
            db.query(`CALL VIEW_SEARCH_NOTINVITED(${roomId}, ${userId}, '${eFactor}');`, (err, res) => { if (err) return console.log(err);
                        callback(res[0]);
            })
        });

        socket.on('inviteRoom', (inviteList, callback) => {
            const roomId = socket.room_id;
            len = inviteList.length;

            for(let i=0; i<len; i++) { // 생성할 방에 유저 초대
                db.query(`CALL UPDATE_INVITE_ROOM(${roomId}, ${inviteList[i]});`, (err, res) => { if (err) return console.log(err) }); // 생성한 방에 친구 초대
            }
            callback();
        });

        socket.on('disconnect', () => {
            console.log('[Room] Namespace Disconnected');
        });
    });

    return Room;
}