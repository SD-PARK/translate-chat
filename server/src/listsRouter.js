const router = require('express').Router();
const listsController = require('./listsController');

router.get('/', listsController.listsGetMid);

router.get('/friendsList', listsController.friendsListGetMid, listsController.friendPrint);

module.exports = router;