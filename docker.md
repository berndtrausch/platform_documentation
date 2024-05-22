> # Dockerfile

```
FROM node:16-alpine
WORKDIR /platform
COPY . .
RUN npm install -g docsify-cli
EXPOSE 3000
CMD ["docsify", "serve", ".", "--port", "3000", "--host", "0.0.0.0"]

```