const db = require('../config/db');
const path = require('path');

exports.listsGetMid = (req, res) => {
    res.redirect('/lists/friendsList');
}

exports.friendsListGetMid = (req, res) => {
    const { user } = req.session;
    res.setHeader('Set-Cookie', 'id='+user.ID);
    res.sendFile('friendsList.html', {root: path.join(__dirname + '/../../view/html/')});
}

exports.roomsListGetMid = (req, res) => {
    // const { user } = req.session;
    // res.setHeader('Set-Cookie', 'id='+user.ID);
    res.sendFile('roomsList.html', {root: path.join(__dirname + '/../../view/html/')});
}