FROM webkul/krayin:2.1.5

# instalar extensão redis (phpredis) e utilitários básicos
RUN apt-get update \
 && apt-get install -y --no-install-recommends php-redis \
 && rm -rf /var/lib/apt/lists/*

# garantir que storage e cache existam e tenham permissão
RUN mkdir -p /var/www/html/laravel-crm/storage/logs \
 && chown -R www-data:www-data /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache \
 && chmod -R ug+rwX /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache
