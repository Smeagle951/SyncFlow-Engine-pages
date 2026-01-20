# 🚀 Guia de Automação - Entrega Automática do Produto

Este guia mostra como automatizar o envio do código de acesso após o pagamento confirmado na Kiwify.

## 📋 Opções de Automação

### Opção 1: Google Forms + Google Drive (Recomendado - Mais Simples) ⭐

#### Passo 1: Criar Google Form
1. Acesse [Google Forms](https://forms.google.com)
2. Crie um novo formulário
3. Adicione os campos:
   - **Nome** (resposta curta)
   - **Email** (resposta curta)
   - **Telefone** (resposta curta - opcional)
   - **Código de Acesso** (resposta curta)
   - **Status** (resposta curta) - valor padrão: "pendente"
4. Clique em "Enviar" → ícone de link → Copie o link
5. Anote o **ID do formulário** (está no link: `forms/d/[ID]/viewform`)

#### Passo 2: Preparar Arquivo no Google Drive
1. Crie um arquivo ZIP com o código do produto
2. Faça upload no Google Drive
3. Clique com botão direito → Compartilhar
4. Copie o link de compartilhamento
5. Ou use link direto do arquivo (será atualizado dinamicamente)

#### Passo 3: Usar Zapier/Make.com (Automação Grátis)
1. Crie conta no [Zapier](https://zapier.com) (versão gratuita permite 5 automações)
2. Crie um novo Zap:
   - **Trigger**: "Google Forms" → "New Form Response"
   - **Action**: "Email" → "Send Outbound Email"
   - Configure:
     - Para: Email coletado no formulário
     - Assunto: "Seu acesso ao OfflineSync Pro foi liberado!"
     - Corpo: Template de email com código de acesso e link do Drive

#### Passo 4: Atualizar checkout.html
Substitua a URL do Kiwify por uma URL que salve no Google Forms ANTES de redirecionar:

```javascript
// No checkout.html, antes de redirecionar:
const formUrl = 'https://docs.google.com/forms/d/e/YOUR_FORM_ID/formResponse';
const formData = new FormData();
formData.append('entry.XXXXXXX', nome); // Substitua X pelos IDs do formulário
formData.append('entry.YYYYYYY', email);
formData.append('entry.ZZZZZZZ', codigoGerado);

fetch(formUrl, {
    method: 'POST',
    body: formData,
    mode: 'no-cors'
}).then(() => {
    window.location.href = 'https://pay.kiwify.com.br/hpMHcPO';
});
```

---

### Opção 2: Google Sheets + Google Apps Script (Automação Completa) 🔥

#### Passo 1: Criar Google Sheet
1. Acesse [Google Sheets](https://sheets.google.com)
2. Crie nova planilha
3. Adicione cabeçalhos na primeira linha:
   - A1: Nome
   - B1: Email
   - C1: Telefone
   - D1: Código
   - E1: Status
   - F1: Data

#### Passo 2: Criar Google Apps Script
1. No Google Sheets: Extensões → Apps Script
2. Cole este código:

```javascript
function onFormSubmit(e) {
  const sheet = SpreadsheetApp.getActiveSheet();
  const lastRow = sheet.getLastRow();
  const email = sheet.getRange(lastRow, 2).getValue(); // Coluna B = Email
  const nome = sheet.getRange(lastRow, 1).getValue(); // Coluna A = Nome
  const codigo = 'OFS-' + Date.now().toString(36).toUpperCase();
  
  // Salvar código na planilha
  sheet.getRange(lastRow, 4).setValue(codigo); // Coluna D = Código
  sheet.getRange(lastRow, 5).setValue('enviado'); // Coluna E = Status
  
  // Enviar email
  const assunto = 'Seu acesso ao OfflineSync Pro foi liberado! 🚀';
  const corpo = `
    Olá ${nome},
    
    Obrigado pela sua compra!
    
    Seu código de acesso: ${codigo}
    
    Link do repositório: https://github.com/seu-usuario/offlinesync-pro
    
    Atenciosamente,
    OfflineSync Pro
  `;
  
  MailApp.sendEmail(email, assunto, corpo);
}
```

3. Salve o projeto
4. Configure trigger: Acionadores → Adicionar acionador → onFormSubmit → Ao editar

#### Passo 3: Integrar com checkout
1. Crie Google Form conectado ao Sheet
2. Atualize checkout.html para enviar dados ao form
3. O script enviará email automaticamente!

---

### Opção 3: EmailJS (Envio de Email Direto) 📧

#### Passo 1: Criar conta no EmailJS
1. Acesse [EmailJS](https://www.emailjs.com) (100 emails/mês grátis)
2. Crie conta gratuita
3. Adicione serviço de email (Gmail, Outlook, etc.)
4. Crie template de email
5. Copie Service ID, Template ID e Public Key

#### Passo 2: Atualizar checkout.html
Adicione no `<head>` do checkout.html:

```html
<script src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
<script>
    emailjs.init('YOUR_PUBLIC_KEY');
</script>
```

E no JavaScript do formulário:

```javascript
// Após validar formulário, antes de redirecionar:
emailjs.send('YOUR_SERVICE_ID', 'YOUR_TEMPLATE_ID', {
    to_name: nome,
    to_email: email,
    message: `Seu código de acesso: ${codigoGerado}`
}).then(() => {
    window.location.href = 'https://pay.kiwify.com.br/hpMHcPO';
});
```

---

### Opção 4: Webhook da Kiwify (Mais Profissional) 🎯

#### Passo 1: Configurar Webhook na Kiwify
1. Acesse painel da Kiwify
2. Vá em Configurações → Webhooks
3. Adicione URL do webhook (ex: `https://seu-servidor.com/webhook`)
4. Configure eventos: "Pagamento Confirmado"

#### Passo 2: Criar Servidor Backend
Crie um servidor simples (Node.js) para receber o webhook:

```javascript
// server-webhook.js
const express = require('express');
const nodemailer = require('nodemailer');
const app = express();

app.use(express.json());

app.post('/webhook', async (req, res) => {
    const { customer_email, customer_name, status } = req.body;
    
    if (status === 'paid') {
        // Gerar código
        const codigo = 'OFS-' + Date.now().toString(36).toUpperCase();
        
        // Enviar email
        await sendEmail(customer_email, customer_name, codigo);
        
        res.json({ success: true });
    }
});

async function sendEmail(email, nome, codigo) {
    // Configurar transporter (Gmail, etc.)
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'seu-email@gmail.com',
            pass: 'sua-senha-app'
        }
    });
    
    await transporter.sendMail({
        from: 'seu-email@gmail.com',
        to: email,
        subject: 'Seu acesso ao OfflineSync Pro!',
        html: `
            <h1>Olá ${nome}!</h1>
            <p>Seu código: ${codigo}</p>
            <p>Link: https://github.com/...</p>
        `
    });
}

app.listen(3000);
```

#### Passo 3: Hospedar Servidor
- Use serviços gratuitos: Vercel, Netlify Functions, Railway
- Configure webhook na Kiwify apontando para sua URL

---

### Opção 5: Google Drive + Link Temporário (Mais Simples) 📁

#### Passo 1: Preparar Arquivo
1. Compacte o código em ZIP
2. Faça upload no Google Drive
3. Configure compartilhamento: "Qualquer pessoa com o link"

#### Passo 2: Criar Página de Entrega
1. Crie uma página protegida por senha simples
2. A senha é o código gerado para cada cliente
3. Na página: link direto para download do Google Drive

#### Passo 3: Enviar Email Manualmente
- Use template de email com link da página protegida
- Cada cliente recebe código único
- Você controla quem tem acesso

---

## 🎯 Recomendação Final

**Para começar rápido:** Use **Opção 1 (Google Forms + Zapier)**
- ✅ Grátis
- ✅ Não precisa de código complexo
- ✅ Funciona automaticamente
- ✅ Fácil de configurar

**Para ter mais controle:** Use **Opção 2 (Google Sheets + Apps Script)**
- ✅ Totalmente gratuito
- ✅ Automação completa
- ✅ Sem limites (exceto quotas do Gmail)
- ✅ Personalizável

**Para escala:** Use **Opção 4 (Webhook + Backend)**
- ✅ Profissional
- ✅ Escalável
- ✅ Totalmente automatizado
- ⚠️ Requer hospedagem de servidor

---

## 📝 Template de Email para Todas as Opções

```html
Assunto: Seu acesso ao OfflineSync Pro foi liberado! 🚀

Olá [NOME],

Obrigado pela sua compra do OfflineSync Pro!

📦 O QUE VOCÊ RECEBEU:
✅ Acesso ao repositório privado
✅ Código completo (Flutter + Node.js)
✅ Documentação profissional
✅ Guia de produção

🔑 SEU CÓDIGO DE ACESSO: [CODIGO]
🔗 LINK DO REPOSITÓRIO: [LINK]

📚 PRÓXIMOS PASSOS:
1. Acesse o repositório usando o código acima
2. Siga o guia em docs/setup.md
3. Em caso de dúvidas, consulte docs/

Obrigado pela confiança!

OfflineSync Pro
```

---

## 🆘 Precisa de Ajuda?

Escolha a opção que melhor se encaixa e siga os passos. Se precisar de ajuda específica, entre em contato!
