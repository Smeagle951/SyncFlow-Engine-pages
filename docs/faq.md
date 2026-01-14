# FAQ - OfflineSync Pro

## ❓ Perguntas Frequentes

### Geral

**P: O que é OfflineSync Pro?**
R: É um módulo completo de sincronização offline-first para Flutter + Node.js, pronto para produção.

**P: Preciso saber Flutter e Node.js para usar?**
R: Sim, conhecimento básico de ambas as tecnologias é recomendado.

**P: Posso usar apenas o Flutter ou apenas o Backend?**
R: Sim, mas você precisará adaptar a outra parte. O produto funciona melhor como um conjunto.

**P: É um framework ou biblioteca?**
R: É um módulo aplicado - código pronto que você integra e adapta ao seu projeto.

### Funcionalidades

**P: Quantas entidades posso sincronizar?**
R: O MVP inclui uma entidade de exemplo (`Record`). Você pode estender para quantas precisar seguindo o mesmo padrão.

**P: Como funciona a resolução de conflitos?**
R: Por padrão, usa **Last Write Wins** (última escrita vence). Conflitos são detectados por versão e marcados para revisão.

**P: Posso mudar a estratégia de conflito?**
R: Sim, o código está aberto. Você pode implementar merge manual ou outras estratégias.

**P: Funciona com múltiplos dispositivos?**
R: Sim, cada dispositivo sincroniza independentemente. O servidor mantém a versão mais recente.

**P: Os dados são criptografados?**
R: Não no MVP. Você pode adicionar criptografia conforme sua necessidade.

### Técnico

**P: Qual banco de dados é usado?**
R: SQLite tanto no cliente quanto no servidor (MVP). Você pode trocar o servidor para PostgreSQL facilmente.

**P: Como funciona o sync automático?**
R: O Sync Engine verifica periodicamente (padrão: 30 segundos) e sincroniza registros pendentes.

**P: O que acontece se o servidor estiver offline?**
R: Os dados ficam salvos localmente com status "pending". Quando o servidor voltar, a sincronização ocorre automaticamente.

**P: Como funciona o soft delete?**
R: Registros não são deletados fisicamente. O campo `deleted_at` é preenchido e sincronizado.

**P: Posso usar com outros frameworks além de Flutter?**
R: A lógica do backend é framework-agnóstica. O cliente Flutter precisaria ser adaptado para React Native, por exemplo.

### Integração

**P: Como integro no meu app existente?**
R: 
1. Copie a estrutura de pastas
2. Adapte o modelo `Record` para suas entidades
3. Configure a URL do backend
4. Integre as telas ou use apenas os repositories

**P: Preciso modificar muito código?**
R: Depende. Se seguir o padrão, é só adaptar modelos e telas. Se tiver arquitetura diferente, precisará adaptar mais.

**P: Funciona com Firebase/Appwrite/etc?**
R: O backend atual é Node.js puro. Você pode adaptar para usar outros serviços, mas precisará reescrever partes do código.

### Performance

**P: Quantos registros suporta?**
R: SQLite suporta milhões de registros. A performance depende do tamanho dos dados e da frequência de sync.

**P: O sync é rápido?**
R: Sim, usa sincronização incremental (delta sync) - apenas envia/recebe o que mudou desde a última sync.

**P: Consome muita bateria?**
R: O sync automático a cada 30s pode consumir bateria. Ajuste o intervalo conforme necessário.

### Comercial

**P: Posso usar em projetos comerciais?**
R: Sim, a licença permite uso comercial em seus projetos.

**P: Posso revender o código?**
R: Não, redistribuição e revenda do código não são permitidas.

**P: Preciso dar créditos?**
R: Não é obrigatório, mas é apreciado.

**P: Oferece suporte?**
R: Depende do pacote adquirido. Consulte a documentação de vendas.

### Limitações

**P: Quais são as limitações do MVP?**
R:
- Last Write Wins apenas
- Uma entidade de exemplo
- Sem UI avançada de merge
- Sem background service
- Sem multi-tenant

**P: Quando terá versão Pro?**
R: Depende da demanda. As funcionalidades Pro podem ser implementadas por você ou contratadas separadamente.

**P: Funciona offline 100%?**
R: Sim, todas as operações CRUD funcionam offline. A sincronização ocorre quando há conexão.

### Problemas Comuns

**P: O app não conecta ao backend**
R: Verifique:
- Backend está rodando?
- URL correta em `api_client.dart`?
- Para dispositivo físico, use IP da máquina, não `localhost`
- Firewall bloqueando?

**P: Sincronização não funciona**
R: Verifique:
- Fez login?
- Token JWT válido?
- Internet funcionando?
- Logs do backend

**P: Conflitos não são detectados**
R: Verifique se as versões estão sendo incrementadas corretamente. O backend compara versões para detectar conflitos.

## 💡 Dicas

- Sempre teste offline antes de ir para produção
- Configure o intervalo de sync conforme sua necessidade
- Monitore os logs para entender o comportamento
- Faça backup do banco antes de grandes mudanças
- Use UUIDs para evitar conflitos de ID

## 📞 Suporte

Para dúvidas técnicas, consulte:
- [Arquitetura](./architecture.md)
- [Setup](./setup.md)
- Issues do repositório (se disponível)
