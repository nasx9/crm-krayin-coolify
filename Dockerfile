FROM webkul/krayin:2.1.5

# Instala extensão redis (phpredis) e utilitários para debug/saúde
RUN apt-get update \
 && apt-get install -y --no-install-recommends php-redis curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Copia scripts para dentro da imagem (não depende de bind mount do repo)
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Garante dirs e permissões base (evita erro de log/cache logo de cara)
RUN mkdir -p /var/www/html/laravel-crm/storage/logs \
 && mkdir -p /var/www/html/laravel-crm/bootstrap/cache \
 && chown -R www-data:www-data /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache \
 && chmod -R ug+rwX /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache
