FROM webkul/krayin:2.1.5

SHELL ["/bin/sh", "-lc"]

# Scripts dentro da imagem (não depende de bind mount do repo)
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Permissões do Laravel (evita erro de log/cache)
RUN mkdir -p /var/www/html/laravel-crm/storage/logs \
 && mkdir -p /var/www/html/laravel-crm/bootstrap/cache \
 && chown -R www-data:www-data /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache \
 && chmod -R ug+rwX /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache

# Predis (PHP puro). Elimina a necessidade da extensão phpredis.
# Se já estiver instalado no vendor, esse comando termina rápido.
RUN cd /var/www/html/laravel-crm \
 && (php -r "exit(file_exists('vendor/autoload.php') ? 0 : 1);" \
     && php -r "require 'vendor/autoload.php'; exit(class_exists('Predis\\\\Client') ? 0 : 1);" ) \
    || (composer require predis/predis:^2.2 --no-interaction --no-progress --no-dev)
