# Backend - OfflineSync Pro

Backend Node.js para sincronização offline-first.

## 🚀 Setup Rápido

1. Instale as dependências:
```bash
npm install
```

2. Configure as variáveis de ambiente:
```bash
cp .env.example .env
```

3. Inicie o servidor:
```bash
npm start
```

Para desenvolvimento com auto-reload:
```bash
npm run dev
```

## 📡 Endpoints

### Autenticação

**POST /auth/login**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

Resposta:
```json
{
  "token": "jwt-token-here",
  "user": {
    "id": 1,
    "username": "admin"
  }
}
```

### Sincronização

**POST /sync/push**
Headers: `Authorization: Bearer {token}`

Body:
```json
{
  "records": [
    {
      "uuid": "unique-id",
      "data": { "name": "Teste" },
      "version": 1,
      "deleted_at": null
    }
  ]
}
```

**GET /sync/pull?since=2024-01-01T00:00:00.000Z**
Headers: `Authorization: Bearer {token}`

## 🔐 Credenciais Padrão

- Username: `admin`
- Password: `admin123`

⚠️ **Altere em produção!**

## 📁 Estrutura

```
backend/
├── src/
│   ├── index.js          # Servidor Express
│   ├── database/
│   │   └── db.js         # Configuração SQLite
│   ├── routes/
│   │   ├── auth.js       # Rotas de autenticação
│   │   └── sync.js       # Rotas de sincronização
│   └── middleware/
│       └── auth.js       # Middleware JWT
└── database/
    └── sync.db           # Banco SQLite (criado automaticamente)
```
