const router = require('express').Router();
const listsController = require('./listsController');
const { upload } = require("../config/multer");

router.get('/', listsController.listsGetMid);

router.get('/friendsList', listsController.friendsListGetMid);

router.get('/roomsList', listsController.roomsListGetMid);

router.get('/room/:room_id', listsController.roomJoinGetMid);

router.get('/settingsList', listsController.settingsListGetMid);

router.post('/settingsList', upload.single('img_file'), listsController.settingsListPostMid);

module.exports = router;