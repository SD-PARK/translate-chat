// Server
const express = require('express');
const app = express(); 
const server = require('http').createServer(app);
const io = require('./io')(server);
const PORT = 3000;

// Session Connect
const session = require('./server/config/session');
app.use(session);

app.use(express.static('view')); // root 지정
app.use(express.urlencoded({extended: false})); // query-string

app.set('io', io);

const loginRouter = require('./server/src/loginRouter');
app.use('/login', loginRouter);

const listsRouter = require('./server/src/listsRouter');
app.use('/lists', listsRouter);

server.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});