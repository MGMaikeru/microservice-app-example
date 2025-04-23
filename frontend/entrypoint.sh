#!/bin/sh

export NGINX_PORT=${NGINX_PORT:-8080}

# Reemplaza las variables en nginx.conf.template con valores de entorno
envsubst '$${AUTH_API_ADDRESS} $${TODOS_API_ADDRESS} $${ZIPKIN_URL}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Arranca NGINX
exec nginx -g 'daemon off;'