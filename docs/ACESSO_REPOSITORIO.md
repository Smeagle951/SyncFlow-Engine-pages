# 🔐 Sistema de Acesso ao Repositório - OfflineSync Pro

Este documento explica como funciona o novo sistema de acesso via código único ao repositório no GitHub.

## 📋 Como Funciona

### Fluxo Completo:

1. **Cliente compra no checkout**
   - Preenche nome e email
   - É redirecionado para Kiwify
   - Faz o pagamento

2. **Após pagamento confirmado**
   - Você verifica o pagamento na Kiwify
   - Gera um código único para o cliente (ex: `OFS-ABC12-XYZ34`)
   - Envia email com o código e link: `https://seu-site.com/access.html`

3. **Cliente acessa o repositório**
   - Cliente acessa `access.html`
   - Digita o código recebido
   - Clica em "Acessar Repositório"
   - É redirecionado para o GitHub para aceitar o convite

## 🔧 Configuração do Sistema

### 1. Configurar Repositório no GitHub

1. Crie um repositório **privado** no GitHub
2. Vá em **Settings** → **Manage access** → **Invite a collaborator**
3. Você pode convidar manualmente cada cliente, OU
4. Configure para aceitar colaboradores automaticamente

### 2. Opção A: Convites Manuais (Recomendado)

**Passo a passo:**

1. Quando o pagamento for confirmado:
   - Vá para o repositório no GitHub
   - Settings → Manage access → Invite a collaborator
   - Digite o email do cliente
   - Clique em "Add [email] to this repository"
   - Envie o email com código e link de acesso

2. Cliente recebe email do GitHub:
   - "You've been invited to collaborate"
   - Clica em "View invitation"
   - Aceita o convite
   - Pronto! Tem acesso ao repositório

### 3. Opção B: Link de Convite Direto

Se configurou convites automáticos, pode criar um link direto:

```
https://github.com/seu-usuario/offlinesync-pro/invitations
```

### 4. Atualizar access.html

Abra `access.html` e encontre as linhas:

```javascript
// Linha ~275
const GITHUB_REPO_URL = 'https://github.com/seu-usuario/offlinesync-pro';
const GITHUB_INVITE_URL = 'https://github.com/seu-usuario/offlinesync-pro/invitations';
```

**Substitua:**
- `seu-usuario` pelo seu usuário do GitHub
- `offlinesync-pro` pelo nome do seu repositório

### 5. Gerenciar Códigos Válidos

**Opção 1: Lista no JavaScript (Simples)**

No `access.html`, adicione os códigos válidos:

```javascript
const validCodes = [
    'OFS-ABC12-XYZ34',
    'OFS-DEF56-WXY78',
    // Adicione mais códigos conforme necessário
];
```

**Opção 2: Servidor Backend (Recomendado para Produção)**

Crie um endpoint que valida os códigos:

```javascript
// No servidor
app.get('/api/validate-code/:code', (req, res) => {
    const code = req.params.code;
    // Verificar em banco de dados
    // Retornar true/false
});
```

E no `access.html`:

```javascript
fetch(`/api/validate-code/${code}`)
    .then(res => res.json())
    .then(data => {
        if (data.valid) {
            // Liberar acesso
        }
    });
```

## 📧 Template de Email Atualizado

```
Assunto: Seu acesso ao OfflineSync Pro foi liberado! 🚀

Olá [NOME],

Obrigado pela sua compra do OfflineSync Pro!

Seu pagamento foi confirmado e seu acesso está liberado.

🔑 SEU CÓDIGO DE ACESSO: [CODIGO]

📦 O QUE VOCÊ RECEBEU:
✅ Acesso ao repositório privado no GitHub
✅ Código completo (Flutter + Node.js)
✅ Documentação profissional
✅ Guia de produção
✅ Licença de uso comercial

🎯 COMO ACESSAR:

1. Acesse: https://seu-site.com/access.html
2. Digite seu código: [CODIGO]
3. Clique em "Acessar Repositório"
4. Faça login no GitHub (se necessário)
5. Aceite o convite para colaboração
6. Pronto! Você terá acesso completo ao código

🔗 LINK DIRETO:
https://seu-site.com/access.html

⚠️ IMPORTANTE:
- Este código é pessoal e intransferível
- Guarde este código com segurança
- O acesso ao repositório é permanente
- Em caso de dúvidas, entre em contato via WhatsApp

Obrigado pela confiança!

OfflineSync Pro
```

## 🎯 Vantagens deste Sistema

✅ **Não precisa de ZIP** - Código direto no GitHub
✅ **Acesso permanente** - Cliente sempre tem acesso
✅ **Versionamento** - Você pode atualizar o código e todos terão
✅ **Seguro** - Cada cliente tem seu próprio acesso
✅ **Profissional** - Repositório privado no GitHub
✅ **Fácil gerenciar** - Controle de acesso via GitHub

## 🔄 Processo Automatizado (Futuro)

Você pode automatizar enviando convites via API do GitHub:

1. Criar Personal Access Token no GitHub
2. Quando pagamento confirmar → API envia convite
3. Email automático com código e link

Mas para começar, o processo manual funciona perfeitamente!

## 📝 Notas Importantes

- O código serve como "senha" para acessar a página
- Após validar, o cliente é direcionado ao GitHub
- O GitHub gerencia o acesso real ao repositório
- Você pode remover acesso a qualquer momento no GitHub

## 🆘 Dúvidas Frequentes

**P: O cliente pode compartilhar o código?**
R: O código dá acesso à página, mas o GitHub exige que ele aceite o convite. Você controla quem tem acesso real.

**P: Como remover acesso de um cliente?**
R: No GitHub: Settings → Manage access → Remover colaborador

**P: Posso gerar códigos automaticamente?**
R: Sim! Cada código pode ser gerado como: `OFS-` + timestamp + random string

---

**Sistema pronto para uso!** Configure o repositório e comece a enviar códigos! 🚀
