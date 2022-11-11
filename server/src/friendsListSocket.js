module.exports = (io, db) => {
    const friendsList = io.of('/friendsList');

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

    return friendsList;
}