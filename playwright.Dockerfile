FROM node:22-bookworm

# Change node user to UID 1001 to match runner user
RUN usermod -u 1001 node && groupmod -g 1001 node

USER node
WORKDIR /app

COPY ./package.json ./
COPY ./package-lock.json ./

RUN npm ci
RUN npx playwright install

# Switch to root to run apt install
USER root
RUN npx playwright install-deps
USER node

COPY . .