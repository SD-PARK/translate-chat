const maria = require('mariadb');
const dbConn = maria.createPool({
    host: '127.0.0.1',
    port: 3306,
    user: 'root',
    password: 'root',
    connectionLimit: 5,
    database: 'chat'
});
module.exports = dbConn;