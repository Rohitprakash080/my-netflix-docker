# Use the official Nginx image from the Docker Hub
FROM nginx:stable-alpine

# Set the working directory inside the container
WORKDIR /usr/share/nginx/html

# Copy the contents of the local `netflix-clone` directory to the container's Nginx directory
COPY netflix-clone/ .

# Expose port 80 to the host
EXPOSE 80

# Command to run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
