const db = require('../config/db');
const path = require('path');

exports.listsGetMid = (req, res) => {
    res.redirect('/lists/friendsList');
}

exports.friendsListGetMid = (req, res) => {
    const { user } = req.session;
    const io = req.app.get('io');
    res.setHeader('Set-Cookie', 'id='+user.ID);
    res.sendFile('lists.html', {root: path.join(__dirname + '/../../view/html/')});
}