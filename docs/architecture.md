# Arquitetura - OfflineSync Pro

## Visão Geral

OfflineSync Pro implementa uma arquitetura offline-first com sincronização bidirecional entre cliente (Flutter) e servidor (Node.js).

## 🏗️ Arquitetura do Cliente (Flutter)

### Camadas

```
UI Layer
  ↓
Use Cases / Repositories
  ↓
Data Layer
  ├── Local DataSource (SQLite)
  └── Remote DataSource (HTTP API)
  ↓
Sync Engine
```

### Componentes Principais

#### 1. Local Database (SQLite)
- Persistência local de dados
- Tabelas versionadas
- Soft delete
- Flags de sincronização

#### 2. Sync Engine
- Fila de operações pendentes
- Push incremental
- Pull por timestamp
- Retry automático
- Detecção de conflitos

#### 3. Repository Pattern
- Abstração de acesso a dados
- Operações CRUD
- Integração com Sync Engine

## 🖥️ Arquitetura do Backend (Node.js)

### Stack
- **Runtime**: Node.js
- **Framework**: Express
- **Database**: SQLite
- **Auth**: JWT

### Endpoints

```
POST /auth/login          # Autenticação
POST /sync/push           # Enviar dados do cliente
GET  /sync/pull?since=    # Buscar atualizações
```

### Fluxo de Sincronização

```
Cliente                    Backend
  │                          │
  ├─ POST /sync/push ───────>│
  │  [records pendentes]     │
  │                          ├─ Validar versões
  │                          ├─ Detectar conflitos
  │                          ├─ Atualizar banco
  │<───── {synced, conflicts}│
  │                          │
  ├─ GET /sync/pull ────────>│
  │  ?since=timestamp        │
  │                          ├─ Buscar atualizações
  │<───── {records}          │
  │                          │
```

## 🔄 Fluxo de Sincronização Detalhado

### 1. Operação Local (Criar/Editar/Excluir)

```
Usuário executa ação
  ↓
Repository salva localmente
  ↓
sync_status = 'pending'
  ↓
Sync Engine tenta sincronizar
```

### 2. Push (Cliente → Servidor)

```
Sync Engine busca registros pending
  ↓
Envia lote para /sync/push
  ↓
Backend valida versões
  ↓
Backend atualiza banco
  ↓
Retorna {synced, conflicts, errors}
  ↓
Cliente atualiza sync_status
```

### 3. Pull (Servidor → Cliente)

```
Sync Engine envia timestamp
  ↓
Backend retorna registros atualizados
  ↓
Cliente compara versões
  ↓
Atualiza apenas se versão maior
```

### 4. Resolução de Conflitos

**Estratégia: Last Write Wins**

```
Cliente envia versão N
  ↓
Backend verifica versão local
  ↓
Se servidor >= cliente:
  → Conflito detectado
  → Retorna serverVersion
  ↓
Cliente marca como 'conflict'
  ↓
Próximo push usa versão do servidor + 1
```

## 📊 Modelo de Dados

### Record (Cliente e Servidor)

```typescript
{
  id: number,
  uuid: string,
  data: string,
  version: number,
  sync_status: 'pending' | 'synced' | 'conflict' | 'error',
  updated_at: string,
  deleted_at: string | null
}
```

### Campos de Sincronização

- **uuid**: Identificador único global
- **version**: Número de versão para detecção de conflitos
- **sync_status**: Status da sincronização
- **updated_at**: Timestamp da última atualização
- **deleted_at**: Soft delete

## 🔐 Segurança

- Autenticação JWT
- Tokens com expiração (7 dias)
- Validação de usuário em todas as rotas de sync
- Isolamento de dados por usuário

## ⚡ Performance

- Sincronização incremental (delta sync)
- Índices no banco de dados
- Lotes de operações
- Retry com backoff exponencial (futuro)

## 🚀 Escalabilidade

### Atual (MVP)
- SQLite local e servidor
- Sincronização sequencial
- Um usuário por dispositivo

### Futuro (Pro)
- PostgreSQL no servidor
- Sincronização paralela
- Multi-dispositivo
- Background sync service

## 📝 Limitações Conhecidas

1. **Last Write Wins**: Não há merge manual
2. **Uma entidade**: Apenas `Record` como exemplo
3. **Sem background sync**: Requer app aberto
4. **Sem criptografia**: Dados em texto plano
5. **Sem multi-tenant**: Um banco por instalação
