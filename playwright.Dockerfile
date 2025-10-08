FROM node:22-bookworm

USER node
WORKDIR /app


COPY --chown=node:node ./package.json ./
COPY --chown=node:node ./package-lock.json ./

# Use a cache mount to re-use npm cache even when packages change
RUN --mount=type=cache,target=/home/node/.npm,uid=1000,gid=1000 \
    npm ci

# Use a cache mount to re-use npm cache even when packages change
RUN --mount=type=cache,target=/tmp/playwright-cache,uid=1000,gid=1000 \
    PLAYWRIGHT_BROWSERS_PATH=/tmp/playwright-cache npx playwright install \
    && mkdir -p ~/.cache/ms-playwright \
    && cp -r /tmp/playwright-cache ~/.cache/ms-playwright

# Switch to root to run apt install
USER root
# Use a cache mount to re-use apt cache even when packages change
# Remove docker-clean to stop apt clearing caches
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && npx playwright install-deps
USER node

RUN ls -lah ~/.cache/ms-playwright/

COPY . .