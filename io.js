module.exports = (server) => {
    const db = require('./server/config/db');
    const io = require('socket.io')(server, {path: '/socket.io'});
    // Namespace
    const friendsList = io.of('/friendsList');
    // const RoomList = io.of('/RoomList');
    
    friendsList.on('connection', (socket) => {
        console.log('Socket.io [friendsList] Namespace Connected');

        socket.on('view', (user_id, callback) => {
            db.query(`SELECT NAME, EMAIL, IMG_URL FROM users WHERE ID=${user_id}`, (err, user_result) => {
                if (err) return console.log(err);

                db.query(`SELECT users.NAME, users.EMAIL, users.IMG_URL
                    FROM users, relations
                    WHERE relations.USER_ID="${user_id}" AND users.ID = relations.TARGET_ID`, (err, friends_result) => {
                    if (err) return console.log(err);
                    
                    callback({user_result: user_result[0], friends_result: friends_result});
                });
            });
        })
    
        socket.on('disconnect', () => {
            console.log('[friendsList] Namespace Disconnected');
        });
    });

    // RoomList.on('connection', (socket) => {
    //     console.log('Socket.io [RoomList] Namespace Connected');
    // })

    return io;
}