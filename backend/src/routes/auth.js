const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const db = require('../database/db');

const router = express.Router();

// POST /auth/login
router.post('/login', (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ error: 'Username e password são obrigatórios' });
    }

    db.get(
        'SELECT * FROM users WHERE username = ?',
        [username],
        (err, user) => {
            if (err) {
                return res.status(500).json({ error: 'Erro ao buscar usuário' });
            }

            if (!user) {
                return res.status(401).json({ error: 'Credenciais inválidas' });
            }

            const isValidPassword = bcrypt.compareSync(password, user.password);
            if (!isValidPassword) {
                return res.status(401).json({ error: 'Credenciais inválidas' });
            }

            const token = jwt.sign(
                { userId: user.id, username: user.username },
                process.env.JWT_SECRET || 'default-secret',
                { expiresIn: '7d' }
            );

            res.json({
                token,
                user: {
                    id: user.id,
                    username: user.username
                }
            });
        }
    );
});

module.exports = router;
