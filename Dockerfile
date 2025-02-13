FROM node:alpine
LABEL description="A Dockerfile for build Docsify."
WORKDIR /docs
RUN npm install -g docsify-cli@latest
COPY . .
EXPOSE 3000
ENTRYPOINT ["sh", "-c", "docsify serve ."]