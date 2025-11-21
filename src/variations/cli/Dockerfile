ARG BASE_OS_VERSION='bookworm'
ARG PHP_VERSION='8.5'
ARG PHP_VARIATION='cli'
ARG BASE_REPO='serversideup/php'
ARG TAG_PREFIX=''
ARG IMAGE_VERSION='v4.1.0'
ARG BASE_IMAGE="${BASE_REPO}:${TAG_PREFIX}${PHP_VERSION}-${PHP_VARIATION}-${BASE_OS_VERSION}-${IMAGE_VERSION}"

##########
# CLI: Main Image
##########
FROM ${BASE_IMAGE}

ARG REPOSITORY_BUILD_VERSION='dev'

LABEL org.opencontainers.image.title="yieldstudio/php (cli)" \
    org.opencontainers.image.description="Supercharge your PHP experience. Based off the official PHP images and serversideup/php, yieldstudio/php includes pre-configured PHP extensions and settings for enhanced performance and security. Optimized for Laravel and WordPress." \
    org.opencontainers.image.url="https://yieldstudio.github.io/docker-php/" \
    org.opencontainers.image.source="https://github.com/YieldStudio/docker-php" \
    org.opencontainers.image.documentation="https://yieldstudio.github.io/docker-php/" \
    org.opencontainers.image.vendor="YieldStudio" \
    org.opencontainers.image.authors="Arnaud RITTI (@arnaud-ritti)" \
    org.opencontainers.image.version="${REPOSITORY_BUILD_VERSION}" \
    org.opencontainers.image.licenses="GPL-3.0-or-later"

ARG DEPENDENCY_PACKAGES_ALPINE='icu-data-full'
ARG DEPENDENCY_PACKAGES_DEBIAN=''
ARG DEPENDENCY_PHP_EXTENSIONS='intl'

ENV \
    PHP_VARIABLES_ORDER="GPCS"

USER root

# copy our scripts
COPY --chmod=755 src/common/ /

RUN \
    docker-php-serversideup-dep-install-alpine "${DEPENDENCY_PACKAGES_ALPINE}"; \
    docker-php-serversideup-dep-install-debian "${DEPENDENCY_PACKAGES_DEBIAN}"; \
    # Install PHP Extension installer
    docker-php-serversideup-install-php-ext-installer; \
    # Install default PHP extensions
    install-php-extensions "${DEPENDENCY_PHP_EXTENSIONS}";

USER www-data

ENTRYPOINT ["docker-php-serversideup-entrypoint"]