module.exports = (io, db) => {
    const roomsList = io.of('/roomsList');
    const escapeMap = require('../config/escapeMap');

    roomsList.on('connection', (socket) => {
        console.log('Socket.io [RoomList] Namespace Connected');

        socket.on('view', (user_id, callback) => {
            console.log('RoomList View :', user_id);
            socket.user_id = user_id;
            // ROOM_ID, ROOM_NAME, SEND_TIME, MSG
            let res = [];
            db.query(`CALL VIEW_ROOMSLIST(${user_id});`, (err, roomList) => { if (err) return console.log(err);
                callback(roomList[0]);
            });
        });

        socket.on('friendsSearch', (factor, callback) => {
            const userId = socket.user_id;
            const eFactor = escapeMap(factor);
            db.query(`CALL VIEW_SEARCH_FRIENDS(${userId}, '${eFactor}');`, (err, res) => { if (err) return console.log(err);
                        callback(res[0]);
            })
        });

        socket.on('makeRoom', (inviteList, callback) => {
            const user_id = socket.user_id;
            len = inviteList.length;
            db.query(`CALL UPDATE_MAKEROOM();`, (err, room_id) => { if (err) return console.log(err) // 방 생성 후 ROOM_ID 로드
                const roomId = room_id[0][0].ROOM_ID;

                db.query(`CALL UPDATE_INVITE_ROOM(${roomId}, ${user_id});`, (err, res) => { if (err) return console.log(err) }); // 생성한 방에 본인 초대
                for(let i=0; i<len; i++) { // 생성할 방에 유저 초대
                    db.query(`CALL UPDATE_INVITE_ROOM(${roomId}, ${inviteList[i]});`, (err, res) => { if (err) return console.log(err) }); // 생성한 방에 친구 초대
                }
            });
            callback();
        });

        socket.on('updateCheck', (user_id, callback) => {
            db.query(`CALL GET_ROOMUPDATE(${user_id})`, (err, res) => { if (err) return console.log(err);
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