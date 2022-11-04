const router = require('express').Router();
const loginController = require('./loginController');

router.get('/', loginController.loginGetMid);

router.post('/', loginController.loginPostMid);

//router.get('/signup', loginController.signupGetMid);

router.post('/signup', loginController.signupPostMid);

router.get('/success', loginController.successGetMid);

module.exports = router;