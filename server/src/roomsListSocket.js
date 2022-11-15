module.exports = (io, db) => {
    const roomsList = io.of('/roomsList');

    roomsList.on('connection', (socket) => {
        console.log('Socket.io [RoomList] Namespace Connected');

        socket.on('view', (user_id, callback) => {
            console.log('RoomList View :', user_id);
            socket.user_id = user_id;
            // ROOM_ID, ROOM_NAME, SEND_TIME, MSG
            let res = [];
            db.query(`CALL VIEW_JOINROOM(${user_id});`, (err, roomList) => { if (err) return console.log(err);
                callback(roomList[0]);
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
            db.query(`INSERT INTO ROOM_LIST () VALUE ()`, (err, res) => { if (err) return console.log(err) }); // ROOM_ID 생성
            db.query(`SELECT ROOM_ID FROM ROOM_LIST ORDER BY ROOM_ID DESC LIMIT 1;`, (err, room_id) => { if (err) return console.log(err) // 생성한 ROOM_ID 로드
                room_id[0].ROOM_ID

                db.query(`INSERT INTO room_info (ROOM_ID, USER_ID) VALUE (${room_id[0].ROOM_ID}, ${user_id});`, (err, res) => { if (err) return console.log(err) }); // 생성할 방에 본인 초대
                for(let i=0; i<list_len; i++) { // 생성할 방에 유저 초대
                    db.query(`INSERT INTO room_info (ROOM_ID, USER_ID) VALUE (${room_id[0].ROOM_ID}, ${list[i]});`, (err, res) => { if (err) return console.log(err) });
                }

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

        socket.on('updateCheck', (user_id, callback) => {
            db.query(`CALL VIEW_ROOMUPDATE(${user_id})`, (err, res) => { if (err) return console.log(err);
                if(res[0][0])
                    callback();
            });
        })

        socket.on('disconnect', () => {
            console.log('[roomsList] Namespace Disconnected');
        });
    })

    return roomsList;
}