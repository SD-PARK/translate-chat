const router = require('express').Router();
const loginController = require('./loginController');

router.get('/', loginController.loginGetMid);

router.post('/', loginController.loginPostMid);

router.post('/signup', loginController.signupPostMid);

module.exports = router;