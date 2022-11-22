const router = require('express').Router();
const listsController = require('./listsController');

router.get('/', listsController.listsGetMid);

router.get('/friendsList', listsController.friendsListGetMid);

router.get('/roomsList', listsController.roomsListGetMid);

router.get('/room/:room_id', listsController.roomJoinGetMid);

router.get('/settingsList', listsController.settingsListGetMid);

module.exports = router;