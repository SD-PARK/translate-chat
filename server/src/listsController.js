const db = require('../config/db');
const path = require('path');

exports.listsGetMid = (req, res) => {
    res.redirect('/lists/friendsList');
}

exports.friendsListGetMid = (req, res) => {
    const { user } = req.session;
    res.sendFile('lists.html', {root: path.join(__dirname + '/../../view/html/')});
}