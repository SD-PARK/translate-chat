const db = require('../config/db');
const path = require('path');

exports.listsGetMid = (req, res) => {
    res.redirect('/lists/friendsList');
}

exports.friendsListGetMid = (req, res) => {
    const { user } = req.session;
    if (user) {
        res.setHeader('Set-Cookie', 'id='+user.ID);
        res.sendFile('friendsList.html', {root: path.join(__dirname + '/../../view/html/')});
    } else {
        res.redirect('/login');
    }
}

exports.roomsListGetMid = (req, res) => {
    const { user } = req.session;
    if (user) {
        res.setHeader('Set-Cookie', 'id='+user.ID);
        res.sendFile('roomsList.html', {root: path.join(__dirname + '/../../view/html/')});
    } else {
        res.redirect('/login');
    }
}

exports.roomJoinGetMid = (req, res) => {
    const { user } = req.session;
    if (user) {
        res.sendFile('room.html', {root: path.join(__dirname + '/../../view/html/')});
    } else {
        res.redirect('/login');
    }
}

exports.settingsListGetMid = (req, res) => {
    const { user } = req.session;
    if (user) {
        res.sendFile('settingsList.html', {root: path.join(__dirname + '/../../view/html/')});
    } else {
        res.redirect('/login');
    }
}