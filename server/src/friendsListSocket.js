module.exports = (io, db) => {
    const friendsList = io.of('/friendsList');

    friendsList.on('connection', (socket) => {
        console.log('Socket.io [friendsList] Namespace Connected');

        // FriendsList 로드 시 쿠키 값(user_id) 받아와 친구 목록 조회하고 callback.
        socket.on('view', (user_id, callback) => {
            socket.user_id = user_id;
            db.query(`SELECT ID, NAME, EMAIL, LANGUAGE, IMG_URL FROM users WHERE ID=${user_id}`, (err, user_result) => { if (err) return console.log(err);

                db.query(`SELECT users.ID, users.NAME, users.EMAIL, users.LANGUAGE, users.IMG_URL
                    FROM users, relations
                    WHERE relations.USER_ID=${user_id} AND users.ID = relations.TARGET_ID AND relations.RELATION_TYPE = "FRIEND"`, (err, friends_result) => { if (err) return console.log(err);
                    
                    callback({user_result: user_result[0], friends_result: friends_result});
                });
            });
        });

        socket.on('emailSearch', (factor, callback) => {
            const user_id = socket.user_id;
            db.query(`SELECT ID, EMAIL, NAME, LANGUAGE, IMG_URL FROM users LEFT OUTER JOIN (SELECT * FROM relations WHERE USER_ID = ${user_id}) AS relations
                    ON ID = TARGET_ID WHERE EMAIL LIKE '%${factor}%' AND ID != ${user_id} AND TARGET_ID IS NULL`, (err, lists) => { if (err) return console.log(err);
                    callback(lists);
            });
        });

        socket.on('friendRegister', (target_id) => {
            const user_id = socket.user_id;
            console.log('Friend Register :', user_id, target_id);
            db.query(`INSERT INTO relations (USER_ID, TARGET_ID) VALUE (${user_id}, ${target_id}), (${target_id}, ${user_id})`, (err, res) => { if (err) return console.log(err); });
        });
    
        socket.on('disconnect', () => {
            console.log('[friendsList] Namespace Disconnected');
        });
    });

    return friendsList;
}