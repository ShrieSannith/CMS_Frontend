# Stage 1: Build the React app
FROM node:alpine3.18 as build

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json . 
RUN npm install

# Copy the rest of the app and build it
COPY . . 
RUN npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:1.23-alpine

# Remove the default Nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output from the build stage to the Nginx directory
COPY --from=build /app/build /usr/share/nginx/html

# Add custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 to access the app
EXPOSE 80

# Start Nginx in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]
