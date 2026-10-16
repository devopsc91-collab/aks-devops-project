
FROM node:24-trixie-slim

WORKDIR /app

ENV NODE_ENV=production

# Install the latest available OS security updates
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Install production dependencies reproducibly
COPY package*.json ./
RUN npm ci --omit=dev \
    && npm cache clean --force

COPY app.js ./

EXPOSE 3000

USER node

CMD ["node", "app.js"]
