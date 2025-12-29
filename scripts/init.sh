#!/usr/bin/env sh
set -eu

APP_DIR="${APP_DIR:-/var/www/html/laravel-crm}"
RUN_MIGRATIONS="${RUN_MIGRATIONS:-false}"

echo "[init] start"
echo "[init] APP_DIR=$APP_DIR RUN_MIGRATIONS=$RUN_MIGRATIONS"

sh /scripts/perms.sh || true

cd "$APP_DIR"

# Espera MySQL ficar acessível via PDO
if [ -n "${DB_HOST:-}" ]; then
  echo "[init] waiting mysql ${DB_HOST}:${DB_PORT:-3306}"
  for i in $(seq 1 60); do
    php -r '
      try {
        $h=getenv("DB_HOST"); $p=getenv("DB_PORT")?: "3306";
        $d=getenv("DB_DATABASE"); $u=getenv("DB_USERNAME"); $pw=getenv("DB_PASSWORD");
        new PDO("mysql:host={$h};port={$p};dbname={$d}", $u, $pw);
        exit(0);
      } catch (Exception $e) { exit(1); }
    ' >/dev/null 2>&1 && break
    sleep 2
  done
fi

# Limpa caches para evitar estados ruins após deploy
php artisan optimize:clear >/dev/null 2>&1 || true

# Rodar migrações só quando você decidir
if [ "$RUN_MIGRATIONS" = "true" ]; then
  echo "[init] running migrations"
  php artisan migrate --force || true
fi

echo "[init] done"
