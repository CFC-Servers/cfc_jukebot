FROM node:18-alpine

WORKDIR /usr/src/app

COPY rawon/package*.json ./

RUN npm install

COPY ./rawon/* ./

CMD [ "npm", "start" ]
