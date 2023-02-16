FROM node:16-alpine

WORKDIR /usr/src/app

COPY src/package*.json ./
RUN npm install 

COPY ./src .

RUN npm run deploy

CMD [ "node", "index.js" ]
