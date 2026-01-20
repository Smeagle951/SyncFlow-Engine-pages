# 🔧 Como Configurar Variáveis no EmailJS - Passo a Passo

Guia detalhado para configurar as variáveis do template de email no EmailJS.

## 📋 Pré-requisitos

Você já deve ter:
- ✅ Conta no EmailJS criada
- ✅ Serviço de email configurado (Gmail, etc.)
- ✅ Template criado (ou está criando)

## 🎯 Configuração Passo a Passo

### Passo 1: Criar o Template

1. Acesse: https://dashboard.emailjs.com/admin/template
2. Clique em **"Create New Template"**
3. Dê um nome: `Template OfflineSync Pro` ou similar

### Passo 2: Configurar o Destinatário (To Email)

1. No topo do template, procure pelo campo **"To Email"** ou **"Recipient"**
2. Digite ou selecione: `{{to_email}}`
3. Isso fará o email ser enviado para o email do cliente automaticamente

### Passo 3: Configurar o Assunto (Subject)

1. No campo **"Subject"** ou **"Assunto"**, digite:
   ```
   Seu acesso ao OfflineSync Pro foi liberado! 🚀
   ```
   Ou use variável:
   ```
   Acesso liberado - {{to_name}}
   ```

### Passo 4: Colar o Template HTML

1. Clique na aba **"Content"** ou **"HTML"**
2. Cole o template HTML completo de `docs/TEMPLATE_EMAIL_CONFIRMACAO.html`
3. Ou use o template inline abaixo (versão simplificada)

### Passo 5: Entender as Variáveis

As variáveis no template são substituídas automaticamente pelos valores que você passa no JavaScript.

**Exemplo no template:**
```html
<p>Olá <strong>{{to_name}}</strong>,</p>
```

**Quando você enviar via JavaScript:**
```javascript
{
  to_name: "João Silva"
}
```

**Resultado no email:**
```html
<p>Olá <strong>João Silva</strong>,</p>
```

### Passo 6: Verificar Variáveis no Template

O template já está configurado com as seguintes variáveis:

| Variável no Template | O que faz | Exemplo |
|---------------------|-----------|---------|
| `{{to_name}}` | Nome do cliente | "João Silva" |
| `{{to_email}}` | Email do cliente (destinatário) | "joao@email.com" |
| `{{codigo}}` | Código de acesso gerado | "OFS-ABC12-XYZ34" |
| `{{repo_url}}` | Link do GitHub | "https://github.com/..." |
| `{{access_url}}` | Link da página de acesso | "https://.../access.html" |
| `{{landing_url}}` | Link da landing page | "https://.../index.html" |
| `{{telefone}}` | Telefone formatado | "(45) 9 9126-1695" |
| `{{telefone_link}}` | Telefone para WhatsApp | "554591261695" |

### Passo 7: Testar o Template

1. No EmailJS, clique em **"Test"** ou **"Preview"**
2. Preencha valores de teste:
   - `to_name`: Teste
   - `to_email`: seu-email@teste.com
   - `codigo`: OFS-TEST-12345
   - `repo_url`: https://github.com/Smeagle951/SyncFlow-Engine
   - `access_url`: https://smeagle951.github.io/SyncFlow-Engine-pages/access.html
   - `landing_url`: https://smeagle951.github.io/SyncFlow-Engine-pages
   - `telefone`: (45) 9 9126-1695
   - `telefone_link`: 554591261695
3. Clique em **"Send Test Email"**
4. Verifique se recebeu o email com todas as variáveis preenchidas

### Passo 8: Salvar e Copiar IDs

1. Clique em **"Save"** (Salvar)
2. Anote o **Template ID** (aparece no topo ou URL, ex: `template_abc123xyz`)
3. Volte para **Email Services** e anote o **Service ID** (ex: `service_gmail`)

### Passo 9: Obter Public Key

1. Vá em **Account** → **General**
2. Copie a **Public Key** (ex: `abc123xyz`)

## 🔍 Solução de Problemas

### Variáveis não aparecem no email

**Problema:** As variáveis aparecem como `{{to_name}}` ao invés do valor real.

**Solução:**
1. Verifique se está passando a variável no JavaScript corretamente
2. Confirme que o nome da variável está EXATAMENTE igual:
   - No template: `{{to_name}}`
   - No JavaScript: `to_name: "João"`

### Email não é enviado

**Problema:** Erro ao enviar email.

**Solução:**
1. Verifique se o **Service ID** está correto
2. Verifique se o **Template ID** está correto
3. Verifique se a **Public Key** está configurada
4. Veja o console do navegador (F12) para erros detalhados

### Variável "To Email" não funciona

**Problema:** Email não é enviado para o cliente.

**Solução:**
1. Certifique-se de que `{{to_email}}` está no campo "To Email"
2. No JavaScript, passe `to_email: emailDoCliente`
3. Verifique se o serviço de email está conectado corretamente

## 📝 Exemplo Completo de JavaScript

Depois de configurar o EmailJS, seu `checkout.html` deve ter:

```javascript
// Inicializar (linha ~12)
emailjs.init('SUA_PUBLIC_KEY_AQUI');

// Na função sendEmailWithCode (linha ~363-364)
const serviceID = 'SEU_SERVICE_ID_AQUI'; // Ex: 'service_gmail'
const templateID = 'SEU_TEMPLATE_ID_AQUI'; // Ex: 'template_abc123xyz'

// Template params (já está correto, apenas precisa dos IDs acima)
const templateParams = {
    to_name: nome,
    to_email: email,
    codigo: codigo,
    repo_url: repoUrl,
    access_url: accessUrl,
    landing_url: landingPageUrl,
    telefone: '(45) 9 9126-1695',
    telefone_link: '554591261695'
};
```

## ✅ Checklist Final

Antes de testar, confirme:

- [ ] EmailJS SDK carregado (`<script src="...email.min.js"></script>`)
- [ ] `emailjs.init('SUA_PUBLIC_KEY')` descomentado e com sua Public Key
- [ ] `serviceID` atualizado com seu Service ID
- [ ] `templateID` atualizado com seu Template ID
- [ ] Template no EmailJS tem `{{to_email}}` no campo "To Email"
- [ ] Template tem todas as variáveis: `{{to_name}}`, `{{codigo}}`, etc.
- [ ] Teste de email funcionou no EmailJS

## 🎯 Resultado Esperado

Quando configurado corretamente:

1. Cliente preenche checkout
2. Código é gerado: `OFS-ABC12-XYZ34`
3. EmailJS envia email automaticamente
4. Cliente recebe email com:
   - ✅ Nome personalizado: "Olá João Silva"
   - ✅ Código gerado: "OFS-ABC12-XYZ34"
   - ✅ Links funcionando
   - ✅ Telefone de suporte: "(45) 9 9126-1695"

---

**Siga este guia passo a passo e suas variáveis funcionarão perfeitamente!** 🚀
