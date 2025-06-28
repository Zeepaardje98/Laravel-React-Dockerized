#!/bin/sh
# Substitute environment variables in the template and start nginx

envsubst '$APP_DOMAIN' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'