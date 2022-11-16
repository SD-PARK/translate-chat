module.exports = (io, db) => {
    const friendsList = io.of('/friendsList');

    friendsList.on('connection', (socket) => {
        console.log('Socket.io [friendsList] Namespace Connected');

        // FriendsList 로드 시 쿠키 값(user_id) 받아와 친구 목록 조회하고 callback.
        socket.on('view', (user_id, callback) => {
            socket.user_id = user_id;
            db.query(`CALL VIEW_FRIENDS(${user_id});`, (err, res) => { if (err) return console.log(err);
                callback({user_result: res[0][0], friends_result: res[1]});
            });
        });

        socket.on('emailSearch', (factor, callback) => {
            const user_id = socket.user_id;
            db.query(`CALL VIEW_SEARCH_EMAIL(${user_id}, '${factor}');`, (err, lists) => { if (err) return console.log(err);
                    callback(lists[0]);
            });
        });

        socket.on('friendRegister', (target_id) => {
            const user_id = socket.user_id;
            console.log('Friend Register :', user_id, target_id);
            db.query(`CALL UPDATE_FRIEND_REGISTER(${user_id}, ${target_id});`, (err, res) => { if (err) return console.log(err); });
        });
    
        socket.on('disconnect', () => {
            console.log('[friendsList] Namespace Disconnected');
        });
    });

    return friendsList;
}