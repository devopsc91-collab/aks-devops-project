FROM node:24-bookworm-slim

WORKDIR /app

# Update Debian OS packages
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Update npm and its bundled dependencies
RUN npm install --global npm@latest \
    && npm cache clean --force

COPY package*.json ./

RUN npm install --omit=dev \
    && npm cache clean --force

COPY app.js .

EXPOSE 3000

CMD ["node", "app.js"]
