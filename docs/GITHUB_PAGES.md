# 🚀 Deploy no GitHub Pages

Guia rápido para publicar a landing page do OfflineSync Pro no GitHub Pages.

## Método 1: GitHub Pages Automático (Recomendado)

1. **Faça commit da landing page**:
   ```bash
   git add index.html
   git commit -m "Adiciona landing page para GitHub Pages"
   git push origin main
   ```

2. **Ative o GitHub Pages**:
   - Vá para o repositório no GitHub
   - Clique em **Settings** (Configurações)
   - Role até **Pages** na barra lateral
   - Em **Source**, selecione **Deploy from a branch**
   - Escolha a branch **main** (ou **master**)
   - Selecione a pasta **/ (root)**
   - Clique em **Save**

3. **Aguarde alguns minutos** para o GitHub processar

4. **Acesse sua landing page**:
   - URL: `https://seu-usuario.github.io/nome-do-repositorio/`
   - Exemplo: `https://johndoe.github.io/offlinesync-pro/`

## Método 2: GitHub Pages com Pasta `/docs`

Se preferir manter a landing page em uma pasta separada:

1. **Mova o index.html para a pasta docs**:
   ```bash
   mv index.html docs/index.html
   ```

2. **Ative o GitHub Pages**:
   - Vá para **Settings** → **Pages**
   - Em **Source**, selecione **Deploy from a branch**
   - Escolha a branch **main**
   - Selecione a pasta **/docs**
   - Clique em **Save**

## Personalizando a Landing Page

### Atualizar Links do GitHub

Edite o arquivo `index.html` e procure por:
```html
<a href="https://github.com/seu-usuario/offlinesync-pro">
```

Substitua `seu-usuario/offlinesync-pro` pelo seu usuário e repositório reais.

### Atualizar Email de Contato

Procure por:
```html
<a href="mailto:seu-email@exemplo.com">
```

Substitua pelo seu email real.

### Atualizar Nome/Logo

Se quiser personalizar o logo no header, procure por:
```html
<div class="logo">OfflineSync Pro</div>
```

## Custom Domain (Opcional)

Se você tem um domínio próprio:

1. **Adicione um arquivo CNAME** na raiz do repositório:
   ```
   seu-dominio.com
   ```

2. **Configure DNS** no seu provedor de domínio:
   - Tipo: `CNAME`
   - Nome: `www` (ou `@`)
   - Valor: `seu-usuario.github.io`

3. **Ative HTTPS** nas configurações do GitHub Pages

## Dicas

- ✅ O GitHub Pages atualiza automaticamente quando você faz push
- ✅ Use HTTPS sempre (GitHub Pages oferece HTTPS gratuito)
- ✅ A landing page é responsiva e funciona em mobile
- ✅ Teste sempre após fazer mudanças

## Problemas Comuns

**Página não atualiza**: Aguarde alguns minutos ou limpe o cache do navegador (Ctrl+F5)

**404 Not Found**: Verifique se a branch e pasta estão corretas nas configurações

**Estilos não carregam**: Certifique-se de que todo o CSS está inline no HTML (já está)

## Suporte

Se precisar de ajuda, consulte a [documentação oficial do GitHub Pages](https://docs.github.com/en/pages).
