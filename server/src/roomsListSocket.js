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
                    
                    db.query(`SELECT msg.SEND_TIME, msg.ORIGINAL_MSG AS MSG FROM room_message_${res[i].ROOM_ID} AS msg
                            ORDER BY SEND_TIME DESC LIMIT 1`, (err, result) => { if (err) return console.log(err);
                        res[i].SEND_TIME = result[0].SEND_TIME;
                        res[i].MSG = result[0].MSG;
                        
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
        })

        socket.on('disconnect', () => {
            console.log('[roomsList] Namespace Disconnected');
        });
    })

    return roomsList;
}