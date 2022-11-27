const db = require('../config/db');
const path = require('path');
const sharp = require('sharp'); const fs = require('fs');

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

exports.settingsListPostMid = (req, res) => {
    const userId = req.session.user.ID;
    const { name, language, company, reset } = req.body;

    if(req.file) {
        console.log(1);
        try {
            sharp(req.file.path).resize({width:500}).withMetadata().toBuffer((err, buffer) => { // 이미지 리사이징
                if (err) throw err;
                fs.writeFile(req.file.path, buffer, (err) => {if (err) throw err});
            })
            db.query(`CALL UPDATE_USER_REGISTER_IMG(${userId}, "${req.file.filename}");`, (err, result) => { if (err) return console.log(err); });
        } catch (err) {
            console.log(err);
        }
    }
    if(reset == "1") {
        db.query(`CALL UPDATE_USER_REGISTER_IMG(${userId}, "default_profile.jpg");`, (err, res) => { if (err) return console.log(err); })
    } 
    if(name) {
        db.query(`CALL UPDATE_USER_REGISTER_NAME(${userId}, "${name}");`, (err, res) => { if (err) return console.log(err); });
    }
    if(language) {
        db.query(`CALL UPDATE_USER_REGISTER_LANGUAGE(${userId}, "${language}");`, (err, res) => { if (err) return console.log(err); });
    }
    if(company) {
        db.query(`CALL UPDATE_USER_REGISTER_cName(${userId}, "${company}");`, (err, res) => { if (err) return console.log(err); });
    }

    res.sendFile('settingsList.html', {root: path.join(__dirname + '/../../view/html/')});
}