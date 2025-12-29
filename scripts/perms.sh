#!/usr/bin/env sh
set -eu

APP_DIR="${APP_DIR:-/var/www/html/laravel-crm}"

# tenta detectar usuário comum de webserver
APP_USER="${APP_USER:-}"
if [ -z "${APP_USER}" ]; then
  for u in www-data nginx apache; do
    if id "$u" >/dev/null 2>&1; then
      APP_USER="$u"
      break
    fi
  done
  [ -z "${APP_USER}" ] && APP_USER="www-data"
fi

APP_GROUP="${APP_GROUP:-$APP_USER}"

echo "[perms] APP_DIR=$APP_DIR"
echo "[perms] APP_USER=$APP_USER APP_GROUP=$APP_GROUP"

mkdir -p "$APP_DIR/storage/logs" "$APP_DIR/bootstrap/cache"
touch "$APP_DIR/storage/logs/laravel.log" || true

chown -R "$APP_USER:$APP_GROUP" "$APP_DIR/storage" "$APP_DIR/bootstrap/cache" || true
chmod -R ug+rwX "$APP_DIR/storage" "$APP_DIR/bootstrap/cache" || true

echo "[perms] ok"
