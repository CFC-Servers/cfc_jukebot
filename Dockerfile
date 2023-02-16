FROM node:17.9.1-bullseye-slim
RUN apt-get update && apt-get install -y --no-install-recommends git

WORKDIR /usr/src/app

COPY src/package*.json ./
RUN npm install 

COPY ./src .

# We will use our own
RUN rm -v ./config.js

COPY ./entrypoint.sh .

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
