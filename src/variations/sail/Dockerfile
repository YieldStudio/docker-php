# check=skip=SecretsUsedInArgOrEnv
ARG BASE_OS_VERSION='trixie'
ARG PHP_VERSION='8.5'
ARG BASE_REPO='ghcr.io/yieldstudio/php'
ARG TAG_PREFIX=''
ARG IMAGE_VERSION='v4.1.0'
ARG BASE_IMAGE="${BASE_REPO}:${TAG_PREFIX}${PHP_VERSION}-frankenphp-${BASE_OS_VERSION}-${IMAGE_VERSION}"

########################
# Common
########################
FROM ${BASE_IMAGE} AS common

ARG REPOSITORY_BUILD_VERSION='dev'

LABEL org.opencontainers.image.title="yieldstudio/sail (frankenphp)" \
    org.opencontainers.image.description="Supercharge your PHP experience. Based off the official PHP images and serversideup/php, yieldstudio/php includes pre-configured PHP extensions and settings for enhanced performance and security. Optimized for Laravel and WordPress." \
    org.opencontainers.image.url="https://yieldstudio.github.io/docker-php/" \
    org.opencontainers.image.source="https://github.com/YieldStudio/docker-php" \
    org.opencontainers.image.documentation="https://yieldstudio.github.io/docker-php/" \
    org.opencontainers.image.vendor="YieldStudio" \
    org.opencontainers.image.authors="Arnaud RITTI (@arnaud-ritti)" \
    org.opencontainers.image.version="${REPOSITORY_BUILD_VERSION}" \
    org.opencontainers.image.licenses="GPL-3.0-or-later"


ARG SOPS_VERSION="v3.10.2"
ARG NODE_VERSION=24

ENV AUTORUN_ENABLED=false \
    PHP_VARIABLES_ORDER="GPCS" \
    PHP_OPCACHE_ENABLE=0 \
    XDEBUG_MODE="coverage,debug" \
    XDEBUG_CONFIG="client_host=host.docker.internal client_port=9003" \
    SOPS_AGE_KEY_FILE="${APP_BASE_DIR}/.age-key"

USER root

RUN apt-get update && apt-get upgrade -y \
    && mkdir -p /etc/apt/keyrings \
    && apt-get install -y gnupg gosu curl zip unzip git sqlite3 libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano age  \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm \
    && npm install -g pnpm \
    && npm install -g bun \
    && npx playwright install-deps \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /etc/apt/keyrings/yarn.gpg >/dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && curl -Lo /usr/local/bin/sops https://github.com/getsops/sops/releases/download/$SOPS_VERSION/sops-$SOPS_VERSION.linux.amd64 \
    && chmod +x /usr/local/bin/sops

RUN install-php-extensions xdebug

RUN git config --global --add safe.directory /var/www/html

USER www-data