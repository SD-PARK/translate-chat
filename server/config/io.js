module.exports = (server) => {
    const db = require('./db');
    const io = require('socket.io')(server, {path: '/socket.io'});
    
    // Namespace
    const friendsList = require('../src/friendsListSocket')(io, db);
    const roomsList = require('../src/roomsListSocket')(io, db);
    const room = require('../src/roomSocket')(io, db);

    return io;
}