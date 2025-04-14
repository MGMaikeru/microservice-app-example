#!/bin/sh

# Depuración
echo "Configurando variables de entorno en NGINX config:"
echo "AUTH_API_ADDRESS: ${AUTH_API_ADDRESS}"
echo "TODOS_API_ADDRESS: ${TODOS_API_ADDRESS}"
echo "USERS_API_ADDRESS: ${USERS_API_ADDRESS}"

# Asegurarse de que las variables de entorno estén definidas
: "${AUTH_API_ADDRESS:?Variable de entorno AUTH_API_ADDRESS no está definida}"
: "${TODOS_API_ADDRESS:?Variable de entorno TODOS_API_ADDRESS no está definida}"

# Reemplaza las variables en la plantilla y copia al lugar de Nginx
envsubst '${AUTH_API_ADDRESS} ${TODOS_API_ADDRESS} ${USERS_API_ADDRESS}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Arranca nginx en primer plano
nginx -g "daemon off;"