FROM node:17.9.1-bullseye-slim

WORKDIR /usr/src/app

COPY src/package*.json ./
RUN npm install 

COPY ./src .

# We will use our own
RUN rm -v ./config.js

COPY ./entrypoint.sh .

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
