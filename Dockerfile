
FROM php:7.4-alpine

RUN set -eux; \
  apk add --no-cache \
  bash \
  tini \
  freetype-dev \
  libjpeg-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  zlib-dev \
  openssh-client \
  nodejs \
  nodejs-npm

RUN printf "# composer php cli ini settings\n\
  date.timezone=UTC\n\
  memory_limit=-1\n\
  " > $PHP_INI_DIR/php-cli.ini

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer global -q require laravel/envoy=2.0.1

RUN docker-php-ext-install exif

RUN apk add build-base zlib-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install -j$(nproc) gd

COPY docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]

CMD ["composer"]