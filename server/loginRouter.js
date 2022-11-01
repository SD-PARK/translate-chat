const router = require('express').Router();
const loginController = require('./loginController');

router.get('/', loginController.loginGetMid);

router.post('/', loginController.loginPostMid);

router.get('/success', (req, res) => {
    const { user } = req.session;
    res.send(user);
})

module.exports = router;