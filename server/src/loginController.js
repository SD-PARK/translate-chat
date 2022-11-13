const db = require('../config/db');
const crypto = require('crypto');
const path = require('path');
const sharp = require('sharp'); const fs = require('fs');

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
                res.send("<script>alert('Password wrong.');history.back();</script>");
            }
        } else {
            console.log('login failed: email not found');
            res.send("<script>alert('Email not found.');history.back();</script>");
        }
    });
}

exports.signupPostMid = (req, res) => {
    const { email, password, name, language, company, company_start, company_end} = req.body;
    const crypto_password = hash(password);

    // 필수 사항 DB 입력
    
    db.query(`INSERT INTO USERS(EMAIL, PASSWORD, NAME, LANGUAGE) VALUE
            ("${email}", "${crypto_password}", "${name}", "${language}");`, (err, result) => {
        
        if (err) {
            if (err.code == 'ER_DUP_ENTRY') res.send("<script>alert('Duplicated email.');history.back();</script>"); // 중복되는 이메일이 있을 경우
            return console.log(err);
        } else {
            // 선택 사항 DB 입력 (NULL값 처리를 위해 필수 사항과 구분하여 UPDATE)
            if(req.file) {
                try {
                    sharp(req.file.path).resize({width:600}).withMetadata().toBuffer((err, buffer) => { // 이미지 리사이징
                        if (err) throw err;
                        fs.writeFile(req.file.path, buffer, (err) => {if (err) throw err});
                    })
                    db.query(`UPDATE USERS SET IMG_URL = "${req.file.filename}" WHERE EMAIL = "${email}";`, (err, result) => { if (err) return console.log(err); });
                } catch (err) {
                    console.log(err);
                }
            }
            if(company) {
                db.query(`UPDATE USERS SET COMPANY_NAME = "${company}" WHERE EMAIL = "${email}";`, (err, result) => { if (err) return console.log(err); });
            }
            if(company_start) {
                db.query(`UPDATE USERS SET COMPANY_START = "${company_start}" WHERE EMAIL = "${email}";`, (err, result) => { if (err) return console.log(err); });
            }
            if(company_end) {
                db.query(`UPDATE USERS SET COMPANY_END = "${company_end}" WHERE EMAIL = "${email}";`, (err, result) => { if (err) return console.log(err); });
            }
        }
        res.redirect('/login');
    });
}

function hash(password) {
    return crypto.createHmac('SHA256', SECRET).update(password).digest('hex');
}