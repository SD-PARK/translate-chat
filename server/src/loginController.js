const db = require('../config/db');
const crypto = require('crypto');
const path = require('path');

const SECRET = require('../config/key').CRYPTO_SECRET;

exports.loginGetMid = (req, res) => {
    if (req.session.user) { // 세션에 user 정보가 있다면 success로 이동
        res.redirect('/login/success');
    } else { // 세션에 user 정보가 없다면 login 페이지로 이동
        res.sendFile('login.html', {root: path.join(__dirname + '/../../view/html/')});
    }
}

exports.loginPostMid = (req, res) => {
    const { email, password } = req.body;
    const crypto_password = hash(password);
    

    db.query(`SELECT * FROM USERS WHERE EMAIL="${email}"`, (err, result) => {
        if (err) return console.log(err);
    
        if (result.length) {
            console.log(result); // RowDataPacket <- 이거 오류아님
            if (result[0].PASSWORD === crypto_password) {
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

exports.signupGetMid = (req, res) => {
    const { user } = req.session;
    if (user) {
        res.send(user);
    } else {
        res.redirect('/login');
    }
}

exports.signupPostMid = (req, res) => {
    const { email, password } = req.body;
    const crypto_password = hash(password);

    db.query(`INSERT INTO USERS(EMAIL, PASSWORD, LANGUEGE) VALUE ("${email}", "${crypto_password}", "ko");`, (err, result) => {
        if (err) return console.log(err);

        console.log('signup complete');
        res.redirect('/login');
    });
}

exports.successGetMid = (req, res) => {
    const { user } = req.session;
    if (user) {
        res.send(user);
    } else {
        res.redirect('/login');
    }
}

function hash(password) {
    return crypto.createHmac('SHA256', SECRET).update(password).digest('hex');
}