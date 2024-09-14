const mysql = require('mysql');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'astralixdex',
  password: 'astralixdex_password',
  database: 'astralixdex_db'
});

const userInput = ' OR 1=1; -- ';
const query = 'SELECT * FROM users WHERE username = ? AND password = ?';
const params = [userInput, 'password'];

db.query(query, params, (err, results) => {
  if (err) {
    console.error(err);
  } else {
    console.log(results);
  }
});
