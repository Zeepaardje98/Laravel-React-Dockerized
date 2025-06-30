#!/bin/sh
set -e

# Replace environment variables in the SQL template
envsubst < /docker-entrypoint-initdb.d/init-cloner.sql.template > /docker-entrypoint-initdb.d/init-cloner.sql

# Now call the original MySQL entrypoint with the passed CMD
exec /usr/local/bin/docker-entrypoint.sh "$@"