const express = require('express');
const app = express(); 
const server = require('http').createServer(app);
const PORT = 3000;

app.use(express.static('public'));

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/html/login.html');
});

server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});