const express = require('express');
const app = express();

app.use(express.json());

const validateInput = (req, res, next) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: 'Invalid input' });
  }
  if (username.length < 3 || username.length > 32) {
    return res.status(400).json({ error: 'Invalid username length' });
  }
  if (password.length < 8) {
    return res.status(400).json({ error: 'Invalid password length' });
  }
  next();
};

app.post('/login', validateInput, (req, res) => {
  // Login logic
});
