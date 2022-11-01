const db = require('./config/db');
const path = require('path');

exports.loginGetMid = (req, res) => {
    if (req.session.user) { // 세션에 user 정보가 있다면 success로 이동
        res.redirect('/login/success');
    } else { // 세션에 user 정보가 없다면 login 페이지로 이동
        res.sendFile(path.join(__dirname + '/../public/html/', 'login.html'));
    }
}

exports.loginPostMid = (req, res) => {
    const { email, password } = req.body;
    db.query(`SELECT * FROM USERS WHERE EMAIL="${email}"`, (err, result) => {
        if (err) return console.log(err);
    
        if (result.length) {
            console.log(result);
            if (result[0].PASSWORD === password) {
                console.log('login success');
                req.session.user = result[0];
                res.redirect('/login/success')
            } else {
                console.log('login failed: password wrong')
                res.redirect('/login');
            }
        } else {
            console.log('login failed: email not found');
            res.redirect('/login');
        }
    });
}