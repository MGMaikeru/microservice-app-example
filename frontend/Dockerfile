# Etapa de construcción
FROM node:8.17.0-alpine as build-stage
WORKDIR /app

# Copia los archivos necesarios para instalar dependencias
COPY package*.json ./

# Instala las dependencias necesarias para construir el proyecto
RUN apk add --no-cache --virtual .gyp python make g++ \
  && npm install \
  && apk del .gyp

# Copia el resto de los archivos del proyecto
COPY . .

# Construye el proyecto
RUN npm run build

# Etapa de producción
FROM nginx:stable-alpine as production-stage

# Copia el archivo de configuración de Nginx como plantilla
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf.template

# Copia los archivos estáticos generados en la etapa de construcción
COPY --from=build-stage /app/dist /usr/share/nginx/html/

# Copia el script de entrada para manejar las variables de entorno
COPY ./nginx/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Cambia los permisos de los archivos estáticos
RUN chown -R nginx:nginx /usr/share/nginx/html && \
  chmod -R 755 /usr/share/nginx/html

# Define el script de entrada como punto de entrada
ENTRYPOINT ["/entrypoint.sh"]

# Expone el puerto 80
EXPOSE 80

# Comando por defecto para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]