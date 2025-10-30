# check=skip=SecretsUsedInArgOrEnv
ARG BASE_OS_VERSION='trixie'
ARG PHP_VERSION='8.4'
ARG BASE_REPO='ghcr.io/yieldstudio/php-dev'
ARG BASE_IMAGE="${BASE_REPO}:${PHP_VERSION}-frankenphp-${BASE_OS_VERSION}"

########################
# Common
########################
FROM ${BASE_IMAGE} AS common

ARG SOPS_VERSION="v3.10.2"
ARG NODE_VERSION=24

ENV AUTORUN_ENABLED=false \
    PHP_OPCACHE_ENABLE=0 \
    XDEBUG_MODE="coverage,debug" \
    XDEBUG_CONFIG="client_host=host.docker.internal client_port=9003" \
    SOPS_AGE_KEY_FILE="${APP_BASE_DIR}/.age-key"

USER root

RUN apt-get update && apt-get upgrade -y \
    && mkdir -p /etc/apt/keyrings \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano age  \
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
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