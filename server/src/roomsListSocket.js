module.exports = (io, db) => {
    const roomsList = io.of('/roomsList');

    roomsList.on('connection', (socket) => {
        console.log('Socket.io [RoomList] Namespace Connected');

        socket.on('view', (user_id, callback) => {
            console.log(user_id, '\n\n\n\n\n');
            socket.user_id = user_id;
            // ROOM_ID, ROOM_NAME, SEND_TIME, MSG
            let res = [];
            db.query(`SELECT ROOM_ID, ROOM_NAME, FAVORITES FROM room_info WHERE USER_ID = ${user_id}`, (err, join_room) => { if (err) return console.log(err);
                const join_room_len = join_room.length;
                for(let i=0; i<join_room_len; i++) {
                    res.push({});
                    res[i].ROOM_ID = join_room[i].ROOM_ID;
                    res[i].ROOM_NAME = join_room[i].ROOM_NAME;
                    res[i].FAVORITES = join_room[i].FAVORITES;
                    res[i].SEND_TIME = "";
                    res[i].MSG = "No Messages.";
                    
                    db.query(`SELECT msg.SEND_TIME, msg.ORIGINAL_MSG AS MSG FROM room_message_${res[i].ROOM_ID} AS msg
                            ORDER BY SEND_TIME DESC LIMIT 1`, (err, result) => { if (err) return console.log(err);
                        if(result[0]) {
                            res[i].SEND_TIME = result[0].SEND_TIME;
                            res[i].MSG = result[0].MSG;
                        }
                        callback(res);
                    });
                }
            });
        });

        socket.on('friendsSearch', (data, callback) => {
            db.query(`SELECT users.ID, users.EMAIL, users.NAME, users.IMG_URL FROM users, relations
                    WHERE ((users.EMAIL LIKE '%${data.factor}%') OR (users.NAME LIKE '%${data.factor}%'))
                    AND (users.ID = relations.TARGET_ID AND RELATION_TYPE = 'FRIEND' AND USER_ID = ${data.user_id})`, (err, res) => { if (err) return console.log(err);
                        callback(res);
            })
        });

        socket.on('makeRoom', (list, callback) => {
            const user_id = socket.user_id;
            list_len = list.length;
            console.log('insert');
            db.query(`INSERT INTO ROOM_LIST () VALUE ()`, (err, res) => { if (err) return console.log(err) }); // ROOM_ID 생성
            console.log('select');
            db.query(`SELECT ROOM_ID FROM ROOM_LIST ORDER BY ROOM_ID DESC LIMIT 1;`, (err, room_id) => { if (err) return console.log(err) // 생성한 ROOM_ID 로드
                room_id[0].ROOM_ID

                console.log('insert2');
                db.query(`INSERT INTO room_info (ROOM_ID, USER_ID) VALUE (${room_id[0].ROOM_ID}, ${user_id});`, (err, res) => { if (err) return console.log(err) }); // 생성할 방에 본인 초대
                for(let i=0; i<list_len; i++) { // 생성할 방에 유저 초대
                    db.query(`INSERT INTO room_info (ROOM_ID, USER_ID) VALUE (${room_id[0].ROOM_ID}, ${list[i]});`, (err, res) => { if (err) return console.log(err) });
                }

                console.log('create');
                db.query(`CREATE TABLE room_message_${room_id[0].ROOM_ID} (
                        MSG_NUM int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                        SEND_USER_ID int(11) NOT NULL,
                        ORIGINAL_MSG varchar(1000) CHARACTER SET utf8mb4 NOT NULL,
                        SEND_TIME datetime NOT NULL DEFAULT current_timestamp(),
                        FROM_LANGUAGE varchar(5) NOT NULL,
                        TO_ko varchar(1000) CHARACTER SET utf8mb4,
                        TO_ja varchar(1000) CHARACTER SET utf8mb4,
                        TO_en varchar(1000) CHARACTER SET utf8mb4,
                        \`TO_zh-CN\` varchar(1000) CHARACTER SET utf8mb4,
                        \`TO_zh-TW\` varchar(1000) CHARACTER SET utf8mb4
                    ) CHARSET=utf8;`, (err, res) => { if (err) return console.log(err) }); // 방 생성
            });
            callback();
        });

        socket.on('disconnect', () => {
            console.log('[roomsList] Namespace Disconnected');
        });
    })

    return roomsList;
}