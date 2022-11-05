const router = require('express').Router();
const listsController = require('./listsController');

router.get('/', listsController.listsGetMid);

router.get('/friendsList', listsController.friendsListGetMid);

module.exports = router;