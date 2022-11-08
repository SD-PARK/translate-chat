const router = require('express').Router();
const listsController = require('./listsController');

router.get('/', listsController.listsGetMid);

router.get('/friendsList', listsController.friendsListGetMid);

router.get('/roomsList', listsController.roomsListGetMid);

module.exports = router;