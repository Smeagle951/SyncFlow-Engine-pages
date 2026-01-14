# Flutter App - OfflineSync Pro

Aplicativo Flutter com sincronização offline-first.

## 🚀 Setup Rápido

1. Instale as dependências:
```bash
flutter pub get
```

2. Configure a URL do backend em `lib/data/remote/api_client.dart`:
```dart
static const String baseUrl = 'http://seu-ip:3000';
```

3. Execute o app:
```bash
flutter run
```

## 📱 Funcionalidades

- ✅ CRUD completo offline
- ✅ Sincronização automática
- ✅ Sincronização manual
- ✅ Indicadores de status de sync
- ✅ Resolução de conflitos (Last Write Wins)

## 🏗️ Arquitetura

```
lib/
├── core/
│   └── sync/
│       └── sync_service.dart      # Motor de sincronização
├── data/
│   ├── local/
│   │   └── local_database.dart    # SQLite local
│   └── remote/
│       └── api_client.dart        # Cliente HTTP
├── domain/
│   ├── models/
│   │   └── record.dart            # Modelo de dados
│   └── repositories/
│       └── record_repository.dart  # Camada de repositório
└── ui/
    ├── screens/
    │   └── home_screen.dart       # Tela principal
    └── widgets/
        ├── record_card.dart       # Card de registro
        └── add_record_dialog.dart # Dialog de adicionar/editar
```

## 🔄 Fluxo de Sincronização

1. **Criar/Editar/Excluir**: Dados são salvos localmente com `sync_status = pending`
2. **Push**: Sync Engine envia registros pendentes para o backend
3. **Pull**: Sync Engine busca atualizações do servidor
4. **Conflitos**: Detectados por versão, resolvidos com Last Write Wins

## 📊 Status de Sincronização

- 🟢 **Synced**: Sincronizado com sucesso
- 🟠 **Pending**: Aguardando sincronização
- 🔴 **Conflict**: Conflito detectado
- ⚫ **Error**: Erro na sincronização

## ⚙️ Configuração

### Autenticação

O app precisa fazer login antes de sincronizar. Adicione a lógica de login na inicialização:

```dart
final apiClient = ApiClient();
await apiClient.login('admin', 'admin123');
```
