# Builder
FROM node:18.14.0 AS build
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init
WORKDIR /usr/src/app

RUN npm install -g npm@9.5.0
COPY rawon/package*.json ./
RUN npm ci

# Install ffmpeg-static
RUN npm install --no-save ffmpeg-static && ls -alh node_modules

# Install yt-dlp
RUN mkdir ./scripts && curl -L https://github.com/yt-dlp/yt-dlp/releases/download/2023.01.06/yt-dlp_linux -o scripts/yt-dlp

COPY rawon/src ./src
COPY rawon/tsconfig.json .
COPY rawon/.swcrc .
RUN npx swc ./src -d ./dist
RUN npm prune --omit=dev

RUN rm -rf ./src ./tsconfig.json ./.swcrc

COPY rawon/index.js .
COPY rawon/yt-dlp-utils ./yt-dlp-utils

# Runner
FROM node:18.14.0-bullseye-slim
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg

ENV NODE_ENV production
COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build --chown=node:node /usr/src/app /usr/src/app

USER node
WORKDIR /usr/src/app

CMD [ "dumb-init", "npm", "start" ]
