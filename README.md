# OfflineSync Pro

**Motor profissional de sincronização offline-first para Flutter + Node.js**

---

## 🚨 O Problema

A maioria dos aplicativos Flutter quebra quando fica offline. Dados são perdidos, conflitos surgem silenciosamente e implementar sincronização confiável do zero leva semanas ou meses.

## ✅ A Solução

**OfflineSync Pro** é um sistema completo de sincronização offline-first, testado e pronto para produção.

- ✅ **Persistência offline real** - SQLite local, funciona sem internet
- ✅ **Sincronização confiável** - Fila de operações com retry automático
- ✅ **Controle de versão** - Detecção automática de conflitos
- ✅ **Resolução de conflitos** - Estratégia Last Write Wins (extensível)
- ✅ **Backend Node.js** - Simples, eficiente e escalável
- ✅ **Código limpo** - Clean Architecture, fácil de adaptar

---

## 📦 O Que Está Incluído

### Flutter App
- SQLite local com sqflite
- Sync Engine completo e isolado
- CRUD de exemplo funcional
- Interface pronta para uso
- Arquitetura Clean Architecture

### Backend Node.js
- Express + SQLite (migrável para PostgreSQL)
- Autenticação JWT
- Endpoints de sincronização otimizados
- Detecção e resolução de conflitos
- Validação de versões

### Documentação Profissional
- Guia de setup completo
- Arquitetura técnica detalhada
- **Guia de produção** (como adaptar para produção real)
- FAQ com casos de uso

---

## 🎯 Para Quem É

- **Apps de campo** - Agro, inspeção, logística
- **Aplicações B2B** - Que precisam funcionar offline
- **Startups** - Que precisam de MVP rápido com sync
- **Empresas** - Que querem solução testada, não experimento
- **Desenvolvedores** - Que não querem perder semanas implementando do zero

---

## ⚙️ Tecnologias

- **Flutter** 3.0+
- **SQLite** (sqflite)
- **Node.js** 18+
- **Express**
- **JWT**

---

## 🧠 Como Funciona

1. Dados são salvos **localmente primeiro** (SQLite)
2. Marcados como `pending` para sincronização
3. Sync Engine envia para o backend quando há conexão
4. Backend valida versões e detecta conflitos
5. Conflitos são resolvidos automaticamente (Last Write Wins)
6. App mantém consistência em todos os dispositivos

**Tudo funciona offline. Sincronização é automática quando há internet.**

---

## 📚 Documentação

- [Guia de Setup](./docs/setup.md) - Como rodar localmente
- [Arquitetura](./docs/architecture.md) - Detalhes técnicos
- [Guia de Produção](./docs/PRODUCTION.md) - **Como adaptar para produção**
- [FAQ](./docs/faq.md) - Perguntas frequentes

---

## 🚀 Quick Start

### Backend
```bash
cd backend
npm install
cp .env.example .env
npm start
```

### Flutter App
```bash
cd flutter_app
flutter pub get
flutter run
```

**Credenciais padrão:** `admin` / `admin123`

---

## 💼 Como Adquirir

Este é um produto digital entregue via **GitHub privado**.

### Opção 1: PIX (Brasil)
Envie um email para [seu-email] com:
- Seu GitHub username
- Comprovante de pagamento PIX

Após confirmação, você receberá acesso ao repositório privado.

### Opção 2: Mercado Pago
[Link de pagamento do Mercado Pago]

Após o pagamento, envie seu GitHub username para liberação.

### Opção 3: Stripe (Internacional)
[Link de pagamento do Stripe]

---

## 📋 O Que Você Recebe

Após o pagamento confirmado:

1. **Acesso ao repositório privado no GitHub**
2. **Código completo** - Flutter + Backend
3. **Documentação profissional**
4. **Guia de produção** - Como adaptar para seu projeto
5. **Licença de uso comercial**

---

## ⚠️ Limitações

- Estratégia de conflito: Last Write Wins (pode ser estendida)
- Uma entidade de exemplo (fácil de replicar para outras)
- SQLite no servidor (pode migrar para PostgreSQL - guia incluído)

**Ideal para estender conforme sua necessidade.**

---

## 🔒 Licença

Uso comercial permitido em projetos próprios e de clientes.
Redistribuição, revenda ou compartilhamento do código não permitida.

Veja [LICENSE.txt](./LICENSE.txt) para detalhes completos.

---

## 📞 Suporte

Para dúvidas técnicas, consulte a documentação em `docs/`.

Para questões sobre compra/acesso, envie email para [seu-email].

---

**Pronto para usar. Pronto para produção. Pronto para escalar.**
