FROM node:20
WORKDIR /platform
COPY . .
RUN npm install -g docsify-cli
WORKDIR /docs
EXPOSE 3000
CMD ["docsify serve ."]
