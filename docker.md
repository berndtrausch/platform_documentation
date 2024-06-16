> # Dockerfile

```dockerfile
FROM node:alpine
LABEL description="A Dockerfile for build Docsify."
WORKDIR /docs
RUN npm install -g docsify-cli@latest
COPY . .
EXPOSE 3000/tcp
ENTRYPOINT docsify serve .

```

> # Docker Hub

The image for the documentation is available on Docker Hub. This command gets the latest version and creates a local container.

```bash
docker pull zalegah/platform-docs:latest
```
