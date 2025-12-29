FROM webkul/krayin:2.1.5

SHELL ["/bin/sh", "-lc"]

USER root

# Instala Redis extension para PHP de forma tolerante
RUN set -eux; \
  if command -v apt-get >/dev/null 2>&1; then \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update -o Acquire::ForceIPv4=true; \
    apt-get install -y --no-install-recommends ca-certificates curl; \
    (apt-get install -y --no-install-recommends php-redis || \
     apt-get install -y --no-install-recommends php8.2-redis || \
     apt-get install -y --no-install-recommends php8.3-redis); \
    rm -rf /var/lib/apt/lists/*; \
  elif command -v apk >/dev/null 2>&1; then \
    apk add --no-cache ca-certificates curl; \
    (apk add --no-cache php82-pecl-redis || \
     apk add --no-cache php81-pecl-redis || \
     apk add --no-cache php-pecl-redis); \
  else \
    echo "No supported package manager found (apt-get/apk)"; \
    exit 1; \
  fi

# Scripts dentro da imagem
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Diretórios e permissões para Laravel
RUN mkdir -p /var/www/html/laravel-crm/storage/logs \
 && mkdir -p /var/www/html/laravel-crm/bootstrap/cache \
 && chown -R www-data:www-data /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache \
 && chmod -R ug+rwX /var/www/html/laravel-crm/storage /var/www/html/laravel-crm/bootstrap/cache

# Validação na build, útil para diagnosticar
RUN php -m | grep -i redis || (echo "PHP redis extension not loaded" && exit 1)

# Opcional: voltar a rodar como www-data
USER www-data
