module.exports = (io, db) => {
    const roomsList = io.of('/roomsList');

    roomsList.on('connection', (socket) => {
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

    return roomsList;
}