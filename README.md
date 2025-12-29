# Krayin CRM no Coolify (Docker Compose)

## O que este repo entrega
- Krayin com MySQL e Redis separados
- Worker e Scheduler separados
- Persistência correta: storage/cache/mysql/redis
- Extensão PHP Redis (phpredis) instalada no build
- Init robusto: ajusta permissões, espera DB, limpa cache e opcionalmente roda migrate

## Como subir no Coolify
1) New Resource -> Docker Compose (from Git)
2) Apontar para este repositório
3) Confirmar Docker Compose Location: /docker-compose.yml

## Domínio
- Em "Domains for krayin", colocar apenas:
  crm.catapultadigital.com.br
- Não coloque https://
- Depois clique em Generate Domain e habilite SSL no Coolify

## Variáveis de Ambiente (Coolify)
- Não commite .env
- No Coolify, copie .env.example e preencha os valores
- Obrigatório:
  - APP_KEY (gere com: php artisan key:generate --show)
  - DB_PASSWORD e MYSQL_ROOT_PASSWORD fortes

## Primeiro deploy (recomendação)
1) Defina RUN_MIGRATIONS=true
2) Deploy
3) Após estabilizar, volte RUN_MIGRATIONS=false e deploy novamente

## Debug rápido via SSH
- Ver logs do serviço web:
  docker logs -n 200 <container_krayin>

- Confirmar extensão redis:
  docker exec -it <container_krayin> sh -lc "php -m | grep -i redis || true"

- Gerar APP_KEY:
  docker exec -it <container_krayin> sh -lc "cd /var/www/html/laravel-crm && php artisan key:generate --show"
  Cole o valor no Coolify em APP_KEY e redeploy.

## Backup (produção)
- Faça backup dos volumes:
  - krayin_mysql (dados)
  - krayin_storage (uploads e logs)
  - krayin_redis (opcional)
