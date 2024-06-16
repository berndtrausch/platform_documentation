FROM node:20
WORKDIR /platform
COPY . .
RUN npm install -g docsify-cli
EXPOSE 3000
CMD ["docsify", "serve", "."]
