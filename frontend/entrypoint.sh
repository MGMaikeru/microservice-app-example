#!/bin/sh

# Reemplaza las variables en la plantilla y copia al lugar de Nginx
envsubst < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Arranca nginx en primer plano
nginx -g "daemon off;"