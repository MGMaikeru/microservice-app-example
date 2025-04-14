#!/bin/sh

# filepath: c:\Users\13mig\Documents\Semestre 7\Soft5\microservice-app-example\frontend\nginx\entrypoint.sh
# Reemplaza las variables de entorno en el archivo de configuración de Nginx
envsubst '${AUTH_API_ADDRESS} ${TODOS_API_ADDRESS} ${USERS_API_ADDRESS} ${ZIPKIN_URL}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Verifica el archivo generado para depuración
echo "Generated Nginx config:"
cat /etc/nginx/conf.d/default.conf

# Inicia Nginx en modo foreground
nginx -g "daemon off;"