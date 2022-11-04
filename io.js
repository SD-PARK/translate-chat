module.exports = (server) => {
    const io = require('socket.io')(server, {path: '/socket.io'});
    // Namespace
    const friendsList = io.of('/friendsList');
    // const RoomList = io.of('/RoomList');

    friendsList.on('connection', (socket) => {
        console.log('Socket.io [friendsList] Namespace Connected');

        socket.on('disconnect', () => {
            console.log('[friendsList] Namespace Disconnected');
        });
    });

    // RoomList.on('connection', (socket) => {
    //     console.log('Socket.io [RoomList] Namespace Connected');
    // })

    return io;
}