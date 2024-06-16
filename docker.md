> # Dockerfile

```
FROM node:20
WORKDIR /platform
COPY . .
RUN npm install -g docsify-cli
EXPOSE 3000
CMD ["docsify", "serve", "."]

```

> # Docker Hub

The image for the documentation is available on Docker Hub. This command gets the latest version and creates a local container.

```bash
docker pull zalegah/platform-docs:latest
```
