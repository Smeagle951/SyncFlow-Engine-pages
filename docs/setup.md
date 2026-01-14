# Guia de Setup - OfflineSync Pro

## 📋 Pré-requisitos

- Node.js 18+ instalado
- Flutter 3.0+ instalado
- Git (opcional)

## 🚀 Setup Completo (5 minutos)

### 1. Backend

```bash
cd backend
npm install
cp .env.example .env
npm start
```

O backend estará rodando em `http://localhost:3000`

**Credenciais padrão:**
- Username: `admin`
- Password: `admin123`

### 2. Flutter App

```bash
cd flutter_app
flutter pub get
```

**Importante:** Configure a URL do backend em `lib/data/remote/api_client.dart`:

```dart
static const String baseUrl = 'http://SEU_IP:3000';
```

Para testar no emulador Android:
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

Para testar no dispositivo físico:
```dart
static const String baseUrl = 'http://192.168.1.X:3000'; // IP da sua máquina
```

### 3. Executar

```bash
flutter run
```

## 🧪 Testando

### Teste Offline

1. Abra o app
2. Desligue a internet (modo avião)
3. Crie alguns registros
4. Veja que aparecem com status "Pendente"
5. Ligue a internet
6. Toque no botão de sincronizar
7. Veja os registros mudarem para "Sincronizado"

### Teste de Conflito

1. Crie um registro no app
2. Sincronize
3. Edite o mesmo registro no app
4. Edite o mesmo registro diretamente no banco do servidor
5. Tente sincronizar novamente
6. Veja o conflito ser detectado

## 🔧 Configuração Avançada

### Backend

**Alterar porta:**
```env
PORT=3001
```

**Alterar JWT secret:**
```env
JWT_SECRET=seu-secret-super-seguro
```

**Alterar caminho do banco:**
```env
DB_PATH=./database/production.db
```

### Flutter

**Alterar intervalo de sync automático:**

Em `lib/core/sync/sync_service.dart`:

```dart
syncService.startAutoSync(interval: Duration(minutes: 5));
```

## 🐛 Troubleshooting

### Backend não inicia

- Verifique se a porta 3000 está livre
- Verifique se o Node.js está instalado: `node --version`
- Verifique os logs de erro

### Flutter não conecta ao backend

- Verifique se o backend está rodando
- Verifique a URL em `api_client.dart`
- Para dispositivo físico, use o IP da máquina, não `localhost`
- Verifique firewall/antivírus

### Sincronização não funciona

- Verifique se fez login (adicionar lógica de login)
- Verifique os logs do backend
- Verifique a conexão de internet
- Verifique se o token JWT está sendo enviado

### Banco de dados não cria

- Verifique permissões de escrita
- Verifique o caminho em `DB_PATH`
- Crie o diretório manualmente se necessário

## 📱 Build para Produção

### Backend

```bash
npm install --production
```

### Flutter

```bash
flutter build apk --release
# ou
flutter build ios --release
```

## 🔐 Segurança em Produção

⚠️ **IMPORTANTE:**

1. Altere a senha padrão do admin
2. Use um JWT_SECRET forte
3. Configure HTTPS
4. Adicione rate limiting
5. Configure CORS adequadamente
6. Use variáveis de ambiente para secrets
7. Não commite `.env` no Git

## 📚 Próximos Passos

Para adaptar este projeto para produção, consulte o [Guia de Produção](./PRODUCTION.md).
