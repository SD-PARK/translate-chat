const maria = require('mysql');

const conn = maria.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'root',
    database: 'chat'
});

conn.connect((err, result) => {
    if (err) console.log(err);
});

module.exports = conn;