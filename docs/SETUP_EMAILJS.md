# 📧 Como Configurar EmailJS para Envio Automático

Este guia mostra como configurar o EmailJS para enviar emails automaticamente com o código de acesso ao repositório GitHub.

## 📋 Passo a Passo

### 1. Criar Conta no EmailJS

1. Acesse: https://www.emailjs.com
2. Clique em **Sign Up** (cadastro gratuito)
3. Crie sua conta (100 emails/mês grátis)

### 2. Adicionar Serviço de Email

1. No painel do EmailJS, vá em **Email Services**
2. Clique em **Add New Service**
3. Escolha seu provedor de email:
   - **Gmail** (recomendado)
   - **Outlook**
   - **Yahoo**
   - Ou outro
4. Siga as instruções para conectar sua conta
5. **Anote o Service ID** (ex: `service_gmail`)

### 3. Criar Template de Email

1. Vá em **Email Templates** → **Create New Template**
2. Escolha um template ou comece do zero
3. Cole este template HTML:

```html
<div style="font-family: system-ui, sans-serif, Arial; font-size: 14px; color: #212121;">
  <div style="max-width: 600px; margin: auto;">
    <!-- Header -->
    <div style="text-align: center; background-color: #2563eb; padding: 32px 16px; border-radius: 32px 32px 0 0;">
      <h1 style="color: white; margin: 0; font-size: 28px; font-weight: bold;">🚀 OfflineSync Pro</h1>
      <p style="color: rgba(255, 255, 255, 0.9); margin: 8px 0 0 0; font-size: 14px;">Motor de Sincronização Offline-First</p>
    </div>

    <!-- Content -->
    <div style="padding: 32px 16px; background-color: white;">
      <h1 style="font-size: 26px; margin-bottom: 20px; color: #2563eb;">Seu acesso foi liberado! 🎉</h1>
      
      <p style="margin-bottom: 12px;">Olá <strong>{{to_name}}</strong>,</p>
      
      <p style="margin-bottom: 20px;">Obrigado pela sua compra do <strong>OfflineSync Pro</strong>!</p>
      
      <p style="margin-bottom: 24px;">Seu pagamento foi confirmado e seu acesso ao repositório privado está liberado.</p>

      <!-- Código de Acesso - Destaque -->
      <div style="background-color: #f0fdf4; padding: 24px; border-radius: 12px; margin: 24px 0; border: 2px solid #10b981;">
        <h2 style="margin: 0 0 16px 0; color: #10b981; font-size: 18px; text-align: center;">🔑 Seu Código de Acesso:</h2>
        <div style="background-color: #1f2937; padding: 20px; border-radius: 8px; font-family: 'Courier New', monospace; font-size: 24px; font-weight: bold; color: #10b981; text-align: center; letter-spacing: 3px; border: 2px dashed #10b981;">
          {{codigo}}
        </div>
        <p style="text-align: center; margin: 16px 0 0 0; color: #6b7280; font-size: 12px;">Guarde este código com segurança</p>
      </div>

      <!-- O que você recebeu -->
      <div style="margin: 32px 0;">
        <h2 style="color: #2563eb; font-size: 20px; margin-bottom: 16px;">📦 O que você recebeu:</h2>
        <ul style="margin: 0; padding-left: 20px; line-height: 2.2;">
          <li style="margin-bottom: 8px;"><strong>Acesso ao repositório privado</strong> no GitHub</li>
          <li style="margin-bottom: 8px;"><strong>Código completo</strong> (Flutter + Backend Node.js)</li>
          <li style="margin-bottom: 8px;"><strong>Documentação profissional</strong> completa</li>
          <li style="margin-bottom: 8px;"><strong>Guia de produção</strong> detalhado</li>
          <li style="margin-bottom: 8px;"><strong>Licença de uso comercial</strong></li>
        </ul>
      </div>

      <!-- Como acessar -->
      <div style="background-color: #eff6ff; padding: 24px; border-radius: 12px; margin: 32px 0; border-left: 4px solid #2563eb;">
        <h2 style="color: #2563eb; font-size: 18px; margin: 0 0 16px 0;">🎯 Como acessar o repositório:</h2>
        <ol style="margin: 0; padding-left: 20px; line-height: 2.2;">
          <li style="margin-bottom: 10px;">Acesse: <a href="{{access_url}}" style="color: #2563eb; font-weight: bold; text-decoration: none;">{{access_url}}</a></li>
          <li style="margin-bottom: 10px;">Digite seu código: <strong style="color: #10b981;">{{codigo}}</strong></li>
          <li style="margin-bottom: 10px;">Clique em "Acessar Repositório"</li>
          <li style="margin-bottom: 10px;">Faça login no GitHub (se necessário)</li>
          <li style="margin-bottom: 10px;">Clique em "Accept invitation" para aceitar o convite</li>
          <li>Pronto! Você terá acesso completo ao código</li>
        </ol>
      </div>

      <!-- Botões de Ação -->
      <div style="text-align: center; margin: 32px 0;">
        <a href="{{repo_url}}" 
           target="_blank"
           style="display: inline-block; background-color: #24292e; color: white; padding: 16px 32px; border-radius: 8px; text-decoration: none; font-weight: bold; margin: 8px; font-size: 16px;">
          🔗 Acessar Repositório no GitHub
        </a>
        <br style="margin: 12px 0;">
        <a href="{{access_url}}" 
           target="_blank"
           style="display: inline-block; background-color: #10b981; color: white; padding: 16px 32px; border-radius: 8px; text-decoration: none; font-weight: bold; margin: 8px; font-size: 16px;">
          🔐 Página de Acesso com Código
        </a>
      </div>

      <!-- Importante -->
      <div style="background-color: #fef3c7; border-left: 4px solid #f59e0b; padding: 20px; border-radius: 8px; margin: 32px 0;">
        <p style="margin: 0 0 12px 0; color: #92400e; font-weight: bold; font-size: 16px;">⚠️ Importante:</p>
        <ul style="margin: 0; padding-left: 20px; color: #92400e; line-height: 1.8;">
          <li>Este código é pessoal e intransferível</li>
          <li>Guarde este código com segurança</li>
          <li>O acesso ao repositório é permanente</li>
          <li>Em caso de dúvidas, entre em contato via WhatsApp</li>
        </ul>
      </div>
    </div>

    <!-- Footer -->
    <div style="text-align: center; background-color: #2563eb; padding: 24px 16px; border-radius: 0 0 32px 32px; color: white;">
      <p style="margin: 0 0 16px 0; font-size: 16px; font-weight: bold;">Precisa de ajuda?</p>
      <p style="margin: 0 0 12px 0;">Entre em contato conosco:</p>
      <p style="margin: 0 0 16px 0;">
        <strong>
          <a href="https://wa.me/{{telefone_link}}" 
             target="_blank"
             style="text-decoration: none; outline: none; color: white; font-size: 18px; font-weight: bold;">
            📱 WhatsApp: {{telefone}}
          </a>
        </strong>
      </p>
      <div style="border-top: 1px solid rgba(255, 255, 255, 0.2); margin-top: 20px; padding-top: 16px;">
        <p style="margin: 0; font-size: 12px; opacity: 0.9;">
          Obrigado pela confiança!<br>
          <strong>OfflineSync Pro</strong> - Motor profissional de sincronização offline-first
        </p>
      </div>
    </div>
  </div>
</div>
```

4. **Configure as variáveis no template:**

   No EmailJS, quando você colar o template HTML, você verá campos com `{{nome_variavel}}`.
   
   **Como configurar cada variável:**
   
   - Clique no campo no template que tem `{{to_name}}`
   - No painel direito, em "Variable" ou "Add Variable"
   - Selecione ou digite: `to_name`
   - Repita para cada variável abaixo:
   
   **Lista completa de variáveis:**
   ```
   {{to_name}}          → Campo: "Nome do cliente"
   {{to_email}}         → Campo: "Email do cliente" (usado como destinatário)
   {{codigo}}           → Campo: "Código de acesso gerado"
   {{repo_url}}         → Campo: "Link do repositório GitHub"
   {{access_url}}       → Campo: "Link da página de acesso"
   {{landing_url}}      → Campo: "Link da landing page"
   {{telefone}}         → Campo: "Telefone de contato"
   {{telefone_link}}    → Campo: "Link WhatsApp (apenas números)"
   ```
   
   **OU** você pode deixar o template HTML como está e o EmailJS usará automaticamente os valores passados no JavaScript.

5. **Configurar o campo "To Email" (destinatário):**
   - No topo do template, procure por "To Email" ou "Recipient"
   - Selecione ou digite: `{{to_email}}`
   - Isso fará o email ser enviado para o email do cliente

6. **Salve o template e anote o Template ID:**
   - Clique em "Save" (Salvar)
   - Anote o **Template ID** (ex: `template_abc123xyz`)

### 4. Obter Public Key

1. Vá em **Account** → **General**
2. Copie a **Public Key** (ex: `abc123xyz`)

### 5. Atualizar checkout.html

Abra `checkout.html` e encontre:

```javascript
// Linha ~10
emailjs.init('YOUR_PUBLIC_KEY');
```

**Substitua `YOUR_PUBLIC_KEY` pela sua Public Key**

E encontre:

```javascript
// Linha ~355 (função sendEmailWithCode)
const serviceID = 'YOUR_SERVICE_ID';
const templateID = 'YOUR_TEMPLATE_ID';
```

**Substitua:**
- `YOUR_SERVICE_ID` pelo Service ID (ex: `service_gmail`)
- `YOUR_TEMPLATE_ID` pelo Template ID (ex: `template_access_code`)

### 6. Testar

1. Preencha o checkout no seu site
2. Envie o formulário
3. Verifique se recebeu o email com o código
4. Teste o código na página de acesso

## ✅ Pronto!

Agora quando alguém preencher o checkout:
1. ✅ Código único é gerado automaticamente
2. ✅ Email é enviado automaticamente via EmailJS
3. ✅ Cliente recebe código e link do repositório
4. ✅ Cliente pode acessar o repositório imediatamente

## 📝 Notas Importantes

- **Limite gratuito:** 200 emails/mês
- **Plano pago:** A partir de $15/mês para mais emails
- **Tempo de entrega:** Geralmente instantâneo
- **Taxa de entrega:** Alta (99%+)

## 🆘 Problemas Comuns

**Email não é enviado:**
- Verifique se a Public Key está correta
- Confirme Service ID e Template ID
- Verifique se o serviço de email está conectado
- Veja o console do navegador para erros

**Variáveis não aparecem:**
- Confirme que as variáveis estão com `{{nome_variavel}}`
- Verifique se está passando os valores em `templateParams`

**Email vai para spam:**
- Configure SPF/DKIM no seu provedor de email
- Use um domínio verificado (plano pago)

---

**Configure agora e tenha envio automático funcionando!** 🚀
