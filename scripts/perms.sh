#!/usr/bin/env sh
set -eu

APP_DIR="${APP_DIR:-/var/www/html/laravel-crm}"
APP_USER="${APP_USER:-www-data}"
APP_GROUP="${APP_GROUP:-www-data}"

echo "[perms] App dir: $APP_DIR"
echo "[perms] User: $APP_USER Group: $APP_GROUP"

mkdir -p "$APP_DIR/storage/logs" "$APP_DIR/bootstrap/cache"
touch "$APP_DIR/storage/logs/laravel.log" || true

chown -R "$APP_USER:$APP_GROUP" "$APP_DIR/storage" "$APP_DIR/bootstrap/cache" || true
chmod -R ug+rwX "$APP_DIR/storage" "$APP_DIR/bootstrap/cache" || true

echo "[perms] Done."
