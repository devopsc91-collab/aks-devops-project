
# Stage 1: Build production dependencies
FROM node:24-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev \
    && npm cache clean --force

COPY app.js ./

# Stage 2: Runtime
FROM node:24-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production

# Apply available Alpine package updates and remove package cache
RUN apk upgrade --no-cache \
    && rm -rf /usr/local/lib/node_modules/npm \
              /usr/local/bin/npm \
              /usr/local/bin/npx

COPY --from=build --chown=node:node /app/package.json ./package.json
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/app.js ./app.js

USER node

EXPOSE 3000

CMD ["node", "app.js"]

