const db = require('../config/db');
const path = require('path');
const { nextTick } = require('process');

exports.listsGetMid = (req, res) => {
    res.redirect('/lists/friendsList');
}

exports.friendsListGetMid = (req, res, next) => {
    const io = req.app.get('io');
    
    res.sendFile('lists.html', {root: path.join(__dirname + '/../../view/html/')});
    next();
}

exports.friendPrint = (req, res) => {
    setTimeout(() => {
        const { user } = req.session;
        const io = req.app.get('io');

        // 가공 필요
        io.of('/friendsList').emit('friendPrint', user);
    
        db.query(`SELECT users.NAME, users.EMAIL, users.IMG_URL
                FROM users, relations
                WHERE relations.USER_ID="${user.ID}" AND users.ID = relations.TARGET_ID`, (err, result) => {
    
            if (err) return console.log(err);
        
            if (result.length) {
                for(let i=(result.length-1); i>=0; i--) {
                    io.of('/friendsList').emit('friendPrint', result[i]);
                    console.log(result[i]); // RowDataPacket <- 이거 오류아님
                }
            }
        });
    }, 100)
}

// 1812105@du.ac.kr