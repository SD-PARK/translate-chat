const router = require('express').Router();
const loginController = require('./loginController');
const { upload } = require("../config/multer");

router.get('/', loginController.loginGetMid);

router.post('/', loginController.loginPostMid);

router.post('/signup', upload.single('img_file'), loginController.signupPostMid);

router.get('/logout', loginController.logoutGetMid);

module.exports = router;