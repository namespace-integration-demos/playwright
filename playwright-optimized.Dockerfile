FROM node:22-bookworm

# Change node user to UID 1001 to match runner user
RUN usermod -u 1001 node && groupmod -g 1001 node

USER node
WORKDIR /app


COPY ./package.json ./
COPY ./package-lock.json ./

# Use a cache mount to re-use npm cache even when packages change
RUN --mount=type=cache,target=/home/node/.npm,uid=1001,gid=1001 \
    npm ci

# Use a cache mount to re-use npm cache even when packages change
RUN --mount=type=cache,target=/tmp/playwright-cache,uid=1001,gid=1001 \
    PLAYWRIGHT_BROWSERS_PATH=/tmp/playwright-cache npx playwright install \
    && mkdir -p ~/.cache/ms-playwright \
    && cp -r /tmp/playwright-cache/** ~/.cache/ms-playwright

# Switch to root to run apt install
USER root
# Use a cache mount to re-use apt cache even when packages change
# Remove docker-clean to stop apt clearing caches
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && npx playwright install-deps
USER node

COPY . .