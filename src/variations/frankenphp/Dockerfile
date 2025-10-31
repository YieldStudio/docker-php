# check=skip=SecretsUsedInArgOrEnv
ARG BASE_OS_VERSION='trixie'
ARG PHP_VERSION='8.4'
ARG PHP_VARIATION='frankenphp'
ARG BASE_REPO='serversideup/php'
ARG TAG_PREFIX=''
ARG BASE_IMAGE="${BASE_REPO}:${TAG_PREFIX}${PHP_VERSION}-${PHP_VARIATION}-${BASE_OS_VERSION}-v4.0.0-beta2"

########################
# Common
########################
FROM ${BASE_IMAGE} AS common

ARG DEPENDENCY_PACKAGES_ALPINE='icu-data-full'
ARG DEPENDENCY_PACKAGES_DEBIAN=''
ARG DEPENDENCY_PHP_EXTENSIONS='xml intl gd bcmath exif imagick opentelemetry soap sockets memcached'

USER root

COPY --chmod=755 src/common/ /

COPY src/variations/frankenphp/etc/frankenphp/ /etc/frankenphp/
COPY src/variations/frankenphp/etc/entrypoint.d/ /etc/entrypoint.d/

RUN \
    docker-php-serversideup-dep-install-alpine "${DEPENDENCY_PACKAGES_ALPINE}"; \
    docker-php-serversideup-dep-install-debian "${DEPENDENCY_PACKAGES_DEBIAN}"; \
    # Install PHP Extension installer
    docker-php-serversideup-install-php-ext-installer; \
    # Install default PHP extensions
    install-php-extensions "${DEPENDENCY_PHP_EXTENSIONS}";

USER www-data

####################
# FrankenPHP Final
####################
FROM common AS final

ENTRYPOINT ["docker-php-serversideup-entrypoint"]

CMD ["frankenphp", "run", "--config", "/etc/frankenphp/Caddyfile", "--adapter", "caddyfile"]

HEALTHCHECK --start-period=60s --start-interval=3s --interval=10s --timeout=3s --retries=3 \
    CMD [ "sh", "-c", "curl --insecure --silent --location --show-error --fail http://localhost:${CADDY_HTTP_PORT}${HEALTHCHECK_PATH} || exit 1" ]