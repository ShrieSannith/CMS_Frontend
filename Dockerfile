FROM node:alpine3.18 as build

# Build App
WORKDIR /app
COPY package.json . 
RUN npm install
COPY . . 
RUN npm run build

# Serve with Nginx
FROM nginx:1.23-alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Remove default nginx files and copy the built React app
WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=build /app/build .

# Expose port 80
EXPOSE 80

# Start nginx
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
