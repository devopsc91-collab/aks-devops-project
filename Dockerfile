
# Stage 1: Install production dependencies
FROM node:24-trixie-slim AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev \
    && npm cache clean --force

COPY app.js ./

# Stage 2: Runtime image
FROM node:24-trixie-slim AS runtime

WORKDIR /app

ENV NODE_ENV=production

# Apply available OS security updates
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/local/lib/node_modules/npm \
              /usr/local/bin/npm \
              /usr/local/bin/npx

# Copy only the application and production dependencies
COPY --from=build --chown=node:node /app/package.json ./package.json
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/app.js ./app.js

USER node

EXPOSE 3000

CMD ["node", "app.js"]

