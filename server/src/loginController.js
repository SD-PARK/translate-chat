const db = require('../config/db');
const crypto = require('crypto');
const path = require('path');

const SECRET = require('../config/key').CRYPTO_SECRET;

exports.loginGetMid = (req, res) => {
    if (req.session.user) { // 세션에 user 정보가 있다면 success로 이동
        res.redirect('/lists');
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
            if (result[0].PASSWORD === crypto_password) {
                req.session.user = result[0];
                res.redirect('/lists')
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

exports.signupPostMid = (req, res) => {
    const { email, password } = req.body;
    const { name, languege, company_name, img_url } = {name: 'name', languege: 'ko', company_name: null, img_url: 'default_profile.png'};
    const crypto_password = hash(password);

    // 필수 사항
    db.query(`INSERT INTO USERS(EMAIL, PASSWORD, NAME, LANGUEGE, IMG_URL) VALUE
            ("${email}", "${crypto_password}", "${name}", "${languege}", "${img_url}");`, (err, result) => {
        if (err) return console.log(err);
    });
    // 선택 사항 (NULL값 처리를 위해 필수 사항과 구분하여 UPDATE)
    if(company_name) {
        db.query(`UPDATE USERS SET COMPANY_NAME = "${COMPANY_NAME}" WHERE EMAIL = "${email}";`, (err, result) => {
            if (err) return console.log(err);
        });
    }

    res.redirect('/login');
}

function hash(password) {
    return crypto.createHmac('SHA256', SECRET).update(password).digest('hex');
}