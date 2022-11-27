module.exports = (io, db) => {
    const settingsList = io.of('/settingsList');
    const escapeMap = require('../config/escapeMap');

    settingsList.on('connection', (socket) => {
        console.log('Socket.io [settingsList] Namespace Connected');

        socket.on('callProfile', (userId, callback) => {
            socket.user_id = userId;
            db.query(`CALL VIEW_PROFILE(${userId})`, (err, res) => { if (err) return console.log(err);
                callback(res[0][0]);
            });
        });
    
        socket.on('disconnect', () => {
            console.log('[settingsList] Namespace Disconnected');
        });
    });

    return settingsList;
}