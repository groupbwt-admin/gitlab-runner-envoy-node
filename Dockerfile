ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}

ARG COMPOSER_VERSION=2.6.6
ARG ENVOY_VERSION=2.8.6
ARG NVM_VERSION=0.39.7
ARG NODE_VERSION=lts/iron

ENV COMPOSER_VERSION=$COMPOSER_VERSION
ENV NVM_VERSION=$NVM_VERSION
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=$NODE_VERSION
ENV ENVOY_VERSION=$ENVOY_VERSION
ENV PATH=$PATH:/root/.composer/vendor/bin

RUN apt update \
    && apt install -y \
        tini \
        git \
# removing temporary files
    && apt clean \
    && rm -r /var/lib/apt/lists/*

COPY php.ini ${PHP_INI_DIR}/30-custom.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}

RUN ["/bin/bash", "-c", "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
    && source ${NVM_DIR}/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default"]

COPY docker-entrypoint.sh /

RUN composer global -q require "laravel/envoy=${ENVOY_VERSION}"

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["composer"]