FROM nginx:alpine

# Copiar archivos del build (por ejemplo, React/Vite/etc)
COPY build/ /usr/share/nginx/html/

# Copiar el template y script de entrada
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY entrypoint.sh /entrypoint.sh

# Permisos
RUN chmod +x /entrypoint.sh

# Entrypoint personalizado
ENTRYPOINT ["/entrypoint.sh"]