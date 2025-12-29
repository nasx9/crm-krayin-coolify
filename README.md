# Krayin no Coolify (Docker Compose)

## O que este repo faz
- Sobe Krayin com MySQL e Redis separados
- Cria worker e scheduler separados
- Corrige permissões de storage e cache
- Instala a extensão PHP Redis (phpredis) no build

## Como usar no Coolify
1) Crie um novo Resource: Docker Compose (from Git)
2) Aponte para este repositório
3) No Coolify, configure as variáveis de ambiente:
   - Copie o conteúdo de .env.example e ajuste senhas e domínio
   - Não commite .env com segredos
4) Configure o Domain no serviço "krayin":
   - crm.exemplo.com.br
   - porta interna 80
5) Ative SSL no Coolify
6) Deploy

## Pós deploy
- Acesse o /admin/login e finalize o setup do Krayin, se necessário.
- Se quiser que migrações rodem automaticamente:
  - set RUN_MIGRATIONS=true
  - faça um deploy
  - depois volte para false

## Debug rápido via SSH
- Ver logs do app:
  docker logs -n 200 <container_krayin>

- Ver extensão redis no PHP:
  docker exec -it <container_krayin> sh -lc "php -m | grep -i redis || true"
