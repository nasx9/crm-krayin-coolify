#!/usr/bin/env sh
set -eu

APP_DIR="${APP_DIR:-/var/www/html/laravel-crm}"

echo "[init] Starting init..."
echo "[init] APP_DIR=$APP_DIR"

# Ajusta permissões primeiro
sh /scripts/perms.sh || true

cd "$APP_DIR"

# Espera MySQL
if [ -n "${DB_HOST:-}" ]; then
  echo "[init] Waiting for MySQL at ${DB_HOST:-mysql}:${DB_PORT:-3306}..."
  for i in $(seq 1 60); do
    if php -r 'try { new PDO("mysql:host=".getenv("DB_HOST").";port=".getenv("DB_PORT").";dbname=".getenv("DB_DATABASE"), getenv("DB_USERNAME"), getenv("DB_PASSWORD")); echo "ok\n"; } catch (Exception $e) { exit(1); }' >/dev/null 2>&1; then
      echo "[init] MySQL OK."
      break
    fi
    sleep 2
  done
fi

# Opcional: espera Redis (só se você realmente usar redis)
if [ -n "${REDIS_HOST:-}" ] && [ "${CACHE_DRIVER:-}" = "redis" ]; then
  echo "[init] Redis configured at ${REDIS_HOST:-redis}:${REDIS_PORT:-6379} (not hard-blocking)."
fi

echo "[init] Clearing caches..."
php artisan optimize:clear || true

# Migrações: só se você quiser automatizar
# Eu recomendo deixar isso ligado em ambiente controlado (primeiro deploy) e depois desligar.
if [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
  echo "[init] Running migrations..."
  php artisan migrate --force || true
fi

echo "[init] Done."
