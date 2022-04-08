FROM php:8.1-apache

ARG UID
ARG GID

RUN apt-get update
RUN apt-get install -y tzdata cron wget apt-transport-https lsb-release ca-certificates gnupg2 msmtp perl procps \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libssh2-1-dev libssh2-1 \
        g++ gettext libicu-dev openssl libc-client-dev libkrb5-dev libxml2-dev libfreetype6-dev libgd-dev libmcrypt-dev bzip2 libbz2-dev libtidy-dev libcurl4-openssl-dev libz-dev libmemcached-dev libxslt-dev net-tools libonig-dev libzip-dev zip \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# PHP Configuration
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install bz2
RUN docker-php-ext-install calendar
RUN docker-php-ext-install dba
RUN docker-php-ext-install exif
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install gettext
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-install intl
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install soap
RUN docker-php-ext-install tidy
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install xsl
RUN docker-php-ext-install zip
RUN docker-php-ext-configure hash --with-mhash

RUN pecl install ssh2-1.3.1 && docker-php-ext-enable ssh2

RUN pecl install xdebug-3.1.3 \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Enable apache modules
RUN a2enmod rewrite headers ssl

COPY ./php.ini /usr/local/etc/php/php.ini
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

COPY ./cron /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

RUN mkdir -p /var/log/cron && mkdir -p /var/log/php

RUN usermod -u $UID www-data && groupmod -g $GID www-data

RUN sed -i 's/^exec /service cron start\n\nexec /' /usr/local/bin/apache2-foreground
