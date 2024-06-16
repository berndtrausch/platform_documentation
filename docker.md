> # Dockerfile

```
FROM node:20

# Set the working directory inside the container
WORKDIR /platform

# Copy all files from the current directory to the working directory in the container
COPY . .

# Install docsify-cli globally
RUN npm install -g docsify-cli

# Set the working directory where the docs are located
WORKDIR /docs

# Expose the port that docsify will run on
EXPOSE 3000

# Command to run docsify; use a shell to execute the command
CMD ["sh", "-c", "docsify serve ."]

```

> # Docker Hub

The image for the documentation is available on Docker Hub. This command gets the latest version and creates a local container.

```bash
docker pull zalegah/platform-docs:latest
```
