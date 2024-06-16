FROM node:20.04
WORKDIR /platform
COPY . .
RUN npm install -g docsify-cli
EXPOSE 3000
CMD ["docsify", "serve", "."]
