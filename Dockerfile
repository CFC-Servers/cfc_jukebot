# Builder
FROM node:18.14.0 AS build
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init
WORKDIR /usr/src/app

RUN npm install -g npm@9.5.0
COPY rawon/package*.json ./
RUN npm ci

COPY rawon/src ./src
COPY rawon/tsconfig.json .
COPY rawon/.swcrc .
RUN npx swc ./src -d ./dist
RUN npm prune --omit=dev

RUN rm -rf ./src ./tsconfig.json ./.swcrc
RUN mv ./dist/* ./ && rm -rf ./dist

# Runner
FROM node:18.14.0-bullseye-slim
ENV NODE_ENV production

COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build --chown=node:node /usr/src/app /usr/src/app

USER node
WORKDIR /usr/src/app

RUN ls -alh && ls -alh ../

CMD [ "dumb-init", "npm", "start" ]
