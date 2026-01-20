# 🔧 Como Configurar Google Forms para Automação

Guia passo a passo para configurar Google Forms e automatizar o envio do código.

## 📋 Passo a Passo

### 1. Criar Google Form

1. Acesse: https://forms.google.com
2. Clique em "Formulário em branco"
3. Configure o formulário:
   - **Nome completo** (resposta curta) - Obrigatório
   - **Email** (resposta curta) - Obrigatório
   - **Telefone** (resposta curta) - Opcional
   - **Código de Acesso** (resposta curta) - Preenchido automaticamente
   - **Status** (resposta curta) - Valor padrão: "pendente"

### 2. Obter IDs dos Campos

1. No formulário, clique nos três pontos (⋮) → "Obter link de pré-visualização"
2. Abra em nova aba
3. Inspecione o elemento do campo (F12)
4. Procure por `entry.XXXXXXX` - esse é o ID do campo
5. Anote os IDs de cada campo:
   - Nome: `entry.XXXXXXX`
   - Email: `entry.YYYYYYY`
   - Telefone: `entry.ZZZZZZZ`
   - Código: `entry.AAAAAAA`
   - Status: `entry.BBBBBBB`

### 3. Obter ID do Formulário

1. No Google Form, clique em "Enviar" (icone de envelope)
2. Clique em "Link" (icone de cadeado)
3. Copie o link - exemplo:
   ```
   https://docs.google.com/forms/d/e/1FAIpQLScXXXXX/viewform?usp=pp_url
   ```
4. O ID está entre `/d/e/` e `/viewform`: `1FAIpQLScXXXXX`

### 4. Atualizar checkout.html

Abra `checkout.html` e encontre a seção de redirecionamento (linha ~327).

Substitua:

```javascript
// Redirecionar para o pagamento da Kiwify
window.location.href = 'https://pay.kiwify.com.br/hpMHcPO';
```

Por:

```javascript
// Gerar código único
const codigo = 'OFS-' + Date.now().toString(36).toUpperCase();

// Salvar código junto com dados
checkoutData.codigo = codigo;
localStorage.setItem('checkoutData', JSON.stringify(checkoutData));

// Enviar para Google Forms
const formUrl = 'https://docs.google.com/forms/d/e/YOUR_FORM_ID/formResponse';
const formData = new FormData();
formData.append('entry.XXXXXXX', nome); // ID do campo Nome
formData.append('entry.YYYYYYY', email); // ID do campo Email
formData.append('entry.ZZZZZZZ', checkoutData.telefone || ''); // ID do campo Telefone
formData.append('entry.AAAAAAA', codigo); // ID do campo Código
formData.append('entry.BBBBBBB', 'pendente'); // ID do campo Status

// Enviar (no-cors para funcionar sem CORS)
fetch(formUrl, {
    method: 'POST',
    body: formData,
    mode: 'no-cors'
}).then(() => {
    // Redirecionar para pagamento
    window.location.href = 'https://pay.kiwify.com.br/hpMHcPO';
}).catch(() => {
    // Mesmo se der erro, redireciona (dados salvos no localStorage)
    window.location.href = 'https://pay.kiwify.com.br/hpMHcPO';
});
```

**⚠️ IMPORTANTE:** Substitua:
- `YOUR_FORM_ID` pelo ID do seu formulário
- `entry.XXXXXXX` pelos IDs reais dos campos

### 5. Configurar Planilha Google Sheets (Opcional)

1. No Google Form: Responses → Link to Sheets
2. Crie nova planilha
3. Agora os dados vão direto para a planilha!

### 6. Automação com Zapier (Envio Automático de Email)

1. Acesse: https://zapier.com
2. Crie conta gratuita (5 automações grátis)
3. Clique em "Make a Zap"
4. **Trigger (Gatilho)**:
   - Escolha: "Google Sheets"
   - Evento: "New Spreadsheet Row"
   - Escolha sua planilha
5. **Action (Ação)**:
   - Escolha: "Email by Zapier"
   - Evento: "Send Outbound Email"
   - Configure:
     - To: Email da linha (Coluna B)
     - Subject: "Seu acesso ao OfflineSync Pro foi liberado! 🚀"
     - Body: Template de email com código
6. Teste e ative o Zap!

### 7. Verificar Funcionamento

1. Preencha o checkout no seu site
2. Verifique se os dados aparecem no Google Form/Sheet
3. Confirme se o email foi enviado (se configurou Zapier)

## ✅ Resultado

Agora quando alguém preencher o checkout:
1. ✅ Dados são salvos no Google Forms/Sheets
2. ✅ Código único é gerado automaticamente
3. ✅ Email é enviado automaticamente via Zapier
4. ✅ Cliente recebe código de acesso por email

## 🆘 Problemas Comuns

**Dados não aparecem no Form:**
- Verifique se os IDs dos campos estão corretos
- Use modo `no-cors` no fetch

**Email não é enviado:**
- Verifique configuração do Zapier
- Confirme que o trigger está funcionando

**Código não aparece:**
- Verifique se o código está sendo gerado antes do envio
- Confirme que o campo de código no Form aceita o valor

---

**Pronto!** Agora você tem automação completa sem precisar de servidor! 🎉
