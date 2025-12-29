FROM webkul/krayin:2.1.5

# Instala extensão Redis do PHP (phpredis) e ferramentas mínimas
RUN apt-get update \
 && apt-get install -y --no-install-recommends php-redis ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Garante diretórios e permissões básicas para evitar erro de log/cache
RUN mkdir -p /var/www/html/laravel-crm/storage/logs \
 && mkdir -p /var/www/html/laravel-crm/bootstrap/cache \
 && chown -R www-data:www-data /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache \
 && chmod -R ug+rwX /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache
