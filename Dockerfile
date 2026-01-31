# Stage 1: Build the Vite app
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve it with Nginx
FROM nginx:alpine
# Copy the built files from the previous stage to Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Optional: Add a custom Nginx config if you need specific routing behavior
# For a basic 404 page, the default is usually fine, but this ensures
# that ANY path the user types serves your index.html
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]