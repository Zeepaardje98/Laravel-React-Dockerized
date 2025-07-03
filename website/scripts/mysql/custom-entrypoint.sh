#!/bin/sh
set -e

# Source main db credentials from Docker secret
. /read-db-credentials.sh

# Substitute variables in the SQL template
if [ -f /tmp/init-cloner.sql.template ]; then
  envsubst < /tmp/init-cloner.sql.template > /docker-entrypoint-initdb.d/init-cloner.sql
fi
