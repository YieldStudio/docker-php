ARG BASE_OS_VERSION='bookworm'
ARG PHP_VERSION='8.4'
ARG PHP_VARIATION='cli'
ARG BASE_REPO='serversideup/php'
ARG BASE_IMAGE="${BASE_REPO}:${PHP_VERSION}-cli-${BASE_OS_VERSION}-v4.0.0-beta2"

##########
# CLI: Main Image
##########
FROM ${BASE_IMAGE}

ARG DEPENDENCY_PACKAGES_ALPINE='icu-data-full'
ARG DEPENDENCY_PACKAGES_DEBIAN=''
ARG DEPENDENCY_PHP_EXTENSIONS='intl'

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