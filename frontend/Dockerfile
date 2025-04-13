# Use an official Node.js runtime as a parent image
FROM node:14 as build-stage

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the Vue.js application
RUN npm run build

# Production stage
FROM nginx:stable-alpine as production-stage

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built Vue app to nginx static directory
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose the port the app runs on
EXPOSE 80

# Start the application
CMD ["nginx", "-g", "daemon off;"]