const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config();

const DB_PATH = process.env.DB_PATH || path.join(__dirname, '../../database/sync.db');

// Garantir que o diretório existe
const dbDir = path.dirname(DB_PATH);
if (!fs.existsSync(dbDir)) {
  fs.mkdirSync(dbDir, { recursive: true });
}

const db = new sqlite3.Database(DB_PATH, (err) => {
  if (err) {
    console.error('❌ Erro ao conectar ao banco:', err.message);
  } else {
    console.log('✅ Conectado ao SQLite');
  }
});

// Inicializar tabelas
db.serialize(() => {
  // Tabela de usuários
  db.run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  // Tabela de records (entidade de exemplo)
  db.run(`CREATE TABLE IF NOT EXISTS records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid TEXT UNIQUE NOT NULL,
    data TEXT NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id)
  )`);

  // Índices para performance
  db.run(`CREATE INDEX IF NOT EXISTS idx_records_uuid ON records(uuid)`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_records_updated_at ON records(updated_at)`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_records_user_id ON records(user_id)`);

  // Criar usuário padrão (senha: admin123)
  const bcrypt = require('bcryptjs');
  const defaultPassword = bcrypt.hashSync('admin123', 10);
  
  db.run(`INSERT OR IGNORE INTO users (username, password) VALUES (?, ?)`, 
    ['admin', defaultPassword], 
    (err) => {
      if (err) {
        console.error('Erro ao criar usuário padrão:', err);
      } else {
        console.log('✅ Usuário padrão criado (admin/admin123)');
      }
    }
  );
});

module.exports = db;
