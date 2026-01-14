# 🚀 Comandos Git - Push para GitHub

## Sequência Completa de Comandos

Execute estes comandos na ordem:

```bash
# 1. Inicializar repositório Git
git init

# 2. Adicionar todos os arquivos
git add .

# 3. Fazer commit inicial
git commit -m "Initial commit - OfflineSync Pro v1.0.0"

# 4. Renomear branch para main
git branch -M main

# 5. Adicionar remote (seu repositório)
git remote add origin https://github.com/Smeagle951/SyncFlow-Engine.git

# 6. Fazer push
git push -u origin main
```

---

## ⚠️ Antes de Fazer Push

### Verificar se está tudo OK:

1. ✅ `.gitignore` está configurado
2. ✅ Não há arquivos `.env` com credenciais
3. ✅ Não há arquivos `.db` (banco de dados)
4. ✅ `README.md` está atualizado
5. ✅ `LICENSE.txt` está incluído

### Arquivos que NÃO devem ser commitados:

- `backend/.env` (será ignorado)
- `backend/database/*.db` (será ignorado)
- `backend/node_modules/` (será ignorado)
- `flutter_app/build/` (será ignorado)

---

## 🔒 Repositório Privado

**IMPORTANTE:** Certifique-se de que o repositório está como **PRIVATE** no GitHub:

1. Vá em Settings do repositório
2. Scroll até "Danger Zone"
3. Verifique se está marcado como "Private"

---

## ✅ Após o Push

1. Verifique se todos os arquivos foram enviados
2. Teste clonar em outro lugar para confirmar
3. Adicione o primeiro cliente como colaborador quando necessário

---

**Pronto para vender! 🚀**
