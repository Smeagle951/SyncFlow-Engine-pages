# 🚀 Guia de Produção - OfflineSync Pro

Este guia mostra **exatamente** como adaptar o OfflineSync Pro para uso em produção real.

**Você comprou este produto para usar em produção. Este guia te mostra como fazer isso.**

---

## 📋 Checklist de Produção

### Backend

- [ ] Alterar senha padrão do admin
- [ ] Configurar JWT_SECRET forte
- [ ] Configurar HTTPS
- [ ] Migrar para PostgreSQL/MySQL (opcional)
- [ ] Adicionar rate limiting
- [ ] Configurar CORS adequadamente
- [ ] Adicionar logs estruturados
- [ ] Configurar backup do banco
- [ ] Adicionar monitoramento

### Flutter App

- [ ] Configurar URL de produção
- [ ] Adicionar tratamento de erros robusto
- [ ] Configurar analytics (opcional)
- [ ] Otimizar imagens e assets
- [ ] Configurar notificações push (opcional)
- [ ] Testar em diferentes dispositivos
- [ ] Build de release otimizado

---

## 🔧 1. Configurar Backend para Produção

### 1.1 Variáveis de Ambiente

Crie um arquivo `.env` de produção:

```env
NODE_ENV=production
PORT=3000
JWT_SECRET=seu-secret-super-forte-aqui-minimo-32-caracteres
DB_PATH=/var/lib/offlinesync/sync.db

# Opcional: PostgreSQL
# DATABASE_URL=postgresql://user:password@localhost:5432/offlinesync
```

**⚠️ IMPORTANTE:**
- Use um JWT_SECRET forte (mínimo 32 caracteres aleatórios)
- Nunca commite o `.env` no Git
- Use variáveis de ambiente do servidor em produção

### 1.2 Migrar para PostgreSQL (Recomendado)

O projeto usa SQLite por simplicidade. Para produção, migre para PostgreSQL:

#### Instalar dependências:

```bash
npm install pg
```

#### Criar arquivo `backend/src/database/postgres.js`:

```javascript
const { Pool } = require('pg');
const dotenv = require('dotenv');

dotenv.config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Criar tabelas
pool.query(`
  CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE IF NOT EXISTS records (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(255) UNIQUE NOT NULL,
    data TEXT NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    user_id INTEGER REFERENCES users(id)
  );

  CREATE INDEX IF NOT EXISTS idx_records_uuid ON records(uuid);
  CREATE INDEX IF NOT EXISTS idx_records_updated_at ON records(updated_at);
  CREATE INDEX IF NOT EXISTS idx_records_user_id ON records(user_id);
`);

module.exports = pool;
```

#### Atualizar `backend/src/routes/sync.js` para usar PostgreSQL:

Substitua `db.get()`, `db.run()`, `db.all()` por `pool.query()`.

### 1.3 Configurar HTTPS

#### Usando Nginx como reverse proxy:

```nginx
server {
    listen 443 ssl;
    server_name seu-dominio.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

#### Ou usar Let's Encrypt:

```bash
sudo certbot --nginx -d seu-dominio.com
```

### 1.4 Adicionar Rate Limiting

```bash
npm install express-rate-limit
```

Em `backend/src/index.js`:

```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100 // máximo 100 requisições por IP
});

app.use('/sync', limiter);
```

### 1.5 Configurar CORS

Em `backend/src/index.js`:

```javascript
const cors = require('cors');

app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  credentials: true
}));
```

### 1.6 Process Manager (PM2)

```bash
npm install -g pm2
pm2 start backend/src/index.js --name offlinesync
pm2 save
pm2 startup
```

---

## 📱 2. Configurar Flutter App para Produção

### 2.1 Configurar URL de Produção

Em `flutter_app/lib/data/remote/api_client.dart`:

```dart
class ApiClient {
  static const String baseUrl = kReleaseMode
      ? 'https://seu-dominio.com'  // Produção
      : 'http://192.168.1.101:3000'; // Desenvolvimento
}
```

Adicione no topo do arquivo:

```dart
import 'package:flutter/foundation.dart';
```

### 2.2 Build de Release

#### Android:

```bash
cd flutter_app
flutter build apk --release
# ou
flutter build appbundle --release
```

#### iOS:

```bash
flutter build ios --release
```

### 2.3 Configurar ProGuard (Android)

Em `android/app/build.gradle.kts`:

```kotlin
buildTypes {
    release {
        minifyEnabled = true
        shrinkResources = true
        proguardFiles(
            getDefaultProguardFile('proguard-android-optimize.txt'),
            'proguard-rules.pro'
        )
    }
}
```

### 2.4 Adicionar Tratamento de Erros Global

Crie `flutter_app/lib/core/error_handler.dart`:

```dart
class ErrorHandler {
  static void handleError(dynamic error, StackTrace stackTrace) {
    // Log para serviço de monitoramento (Sentry, Firebase, etc)
    print('Error: $error');
    print('Stack: $stackTrace');
    
    // Enviar para serviço de monitoramento
    // Sentry.captureException(error, stackTrace: stackTrace);
  }
}
```

Em `main.dart`:

```dart
void main() async {
  FlutterError.onError = (details) {
    ErrorHandler.handleError(details.exception, details.stack!);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorHandler.handleError(error, stack);
    return true;
  };
  
  // ... resto do código
}
```

---

## 🗄️ 3. Adaptar para Suas Entidades

### 3.1 Criar Novo Modelo

Exemplo: `lib/domain/models/product.dart`:

```dart
class Product {
  final int? id;
  final String uuid;
  final String name;
  final double price;
  final int version;
  final SyncStatus syncStatus;
  final String updatedAt;
  final String? deletedAt;

  Product({
    this.id,
    required this.uuid,
    required this.name,
    required this.price,
    required this.version,
    required this.syncStatus,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'price': price,
      'version': version,
      'sync_status': syncStatus.name,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      uuid: map['uuid'],
      name: map['name'],
      price: map['price']?.toDouble(),
      version: map['version'],
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == map['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
      updatedAt: map['updated_at'],
      deletedAt: map['deleted_at'],
    );
  }
}
```

### 3.2 Adaptar LocalDatabase

Adicione métodos para sua entidade:

```dart
Future<int> insertProduct(Product product) async {
  final db = await instance;
  return await db.insert('products', product.toMap());
}

Future<List<Product>> getAllProducts() async {
  final db = await instance;
  final maps = await db.query('products', where: 'deleted_at IS NULL');
  return maps.map((map) => Product.fromMap(map)).toList();
}
```

### 3.3 Adaptar Backend

Em `backend/src/routes/sync.js`, adicione lógica para sua entidade:

```javascript
// Exemplo para products
router.post('/push/products', async (req, res) => {
  const { products } = req.body;
  // ... lógica similar ao push de records
});
```

---

## 🔐 4. Segurança

### 4.1 Autenticação Robusta

- Implemente refresh tokens
- Adicione expiração de tokens
- Implemente logout que invalida tokens

### 4.2 Validação de Dados

- Valide todos os inputs no backend
- Use bibliotecas como `joi` ou `express-validator`

### 4.3 Criptografia

- Use HTTPS sempre
- Considere criptografar dados sensíveis no banco

---

## 📊 5. Monitoramento

### 5.1 Logs Estruturados

Use `winston` ou `pino`:

```bash
npm install winston
```

### 5.2 Health Checks

Já existe em `/health`. Adicione mais métricas:

```javascript
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    memory: process.memoryUsage()
  });
});
```

### 5.3 Analytics

- Firebase Analytics (Flutter)
- Google Analytics
- Sentry para erros

---

## 🚀 6. Deploy

### 6.1 Backend (VPS/Cloud)

```bash
# Usando PM2
pm2 start backend/src/index.js --name offlinesync

# Ou usando Docker
docker build -t offlinesync-backend .
docker run -d -p 3000:3000 offlinesync-backend
```

### 6.2 Flutter App

- **Android**: Publique no Google Play Store
- **iOS**: Publique na App Store

---

## ✅ Checklist Final

Antes de ir para produção:

- [ ] Testes completos (offline/online)
- [ ] Backup configurado
- [ ] Monitoramento ativo
- [ ] Logs configurados
- [ ] HTTPS configurado
- [ ] Rate limiting ativo
- [ ] CORS configurado
- [ ] Senhas alteradas
- [ ] JWT_SECRET forte
- [ ] Build de release testado

---

**Pronto para produção! 🚀**
