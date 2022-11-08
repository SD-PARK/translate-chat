module.exports = (server) => {
    const db = require('./server/config/db');
    const io = require('socket.io')(server, {path: '/socket.io'});
    
    // Namespace
    const friendsList = io.of('/friendsList');
    const RoomList = io.of('/roomsList');
    
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
        })
    
        socket.on('disconnect', () => {
            console.log('[friendsList] Namespace Disconnected');
        });
    });

    RoomList.on('connection', (socket) => {
        console.log('Socket.io [RoomList] Namespace Connected');

        socket.on('view', (user_id, callback) => {
            // ROOM_ID, ROOM_NAME, SEND_TIME, MSG
            db.query(`SELECT info.ROOM_ID, info.ROOM_NAME, msg.SEND_TIME, msg.ORIGINAL_MSG AS MSG FROM room_info AS info,
                    (SELECT * FROM room_message_1 ORDER BY SEND_TIME DESC LIMIT 1) AS msg WHERE USER_ID = ${user_id} AND FAVORITES = 1`, (err, favorites_result) => {
                        if (err) return console.log(err);

                        db.query(`SELECT info.ROOM_ID, info.ROOM_NAME, msg.SEND_TIME, msg.ORIGINAL_MSG AS MSG FROM room_info AS info,
                                (SELECT * FROM room_message_1 ORDER BY SEND_TIME DESC LIMIT 1) AS msg WHERE USER_ID = ${user_id} AND FAVORITES = 0`, (err, normal_result) => {
                                    if (err) return console.log(err);
                                    callback({favorites_result, normal_result});
                        });
                    });
        });

        socket.on('disconnect', () => {
            console.log('[roomsList] Namespace Disconnected');
        });
    })

    return io;
}