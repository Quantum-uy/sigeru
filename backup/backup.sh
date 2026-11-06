#!/bin/sh
set -eu

FECHA=$(date +%Y-%m-%d_%H-%M-%S)
TMP="/tmp/respaldo_$FECHA"
ARCHIVO="/backups/sigeru_$FECHA.tar.gz"
mkdir -p "$TMP/sitio" /backups

echo "Respaldando base de datos..."
mysqldump \
  -h "$MYSQL_HOST" \
  -u"$MYSQL_USER" \
  -p"$MYSQL_PASSWORD" \
  --single-transaction \
  --no-tablespaces \
  "$MYSQL_DATABASE" > "$TMP/sigeru.sql"

echo "Copiando archivos del sitio..."
tar \
  --exclude='./.git' \
  --exclude='./.env' \
  --exclude='./backup' \
  --exclude='./db' \
  -cf - -C /source_app . | tar -xf - -C "$TMP/sitio"

echo "Comprimiendo respaldo..."
tar -czf "$ARCHIVO" -C "$TMP" .
rm -rf "$TMP"

echo "Verificando integridad..."
tar -tzf "$ARCHIVO" > /dev/null
echo "Backup OK: $ARCHIVO ($(du -h "$ARCHIVO" | cut -f1))"
