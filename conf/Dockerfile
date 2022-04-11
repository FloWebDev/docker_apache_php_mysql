FROM php:8.1-apache

ARG UID
ARG GID

# Install packages
RUN apt-get update
RUN apt-get install -y tzdata cron wget apt-transport-https lsb-release ca-certificates gnupg2 msmtp perl procps \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libssh2-1-dev libssh2-1 \
        g++ gettext libicu-dev openssl libc-client-dev libkrb5-dev libxml2-dev libfreetype6-dev libgd-dev libmcrypt-dev bzip2 libbz2-dev libtidy-dev libcurl4-openssl-dev libz-dev libmemcached-dev libxslt-dev net-tools libonig-dev libzip-dev zip \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd

# timezone Apache server
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# PHP Configuration
RUN docker-php-ext-install bcmath bz2 calendar dba exif fileinfo gettext intl pdo pdo_mysql mysqli soap tidy mbstring xsl zip \
        && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
        && docker-php-ext-install imap

# php-ssh2
RUN pecl install ssh2-1.3.1 && docker-php-ext-enable ssh2

# xdebug
RUN pecl install xdebug-3.1.3 \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Composer
RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Configuration php.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && echo "display_errors = On" >> "$PHP_INI_DIR/php.ini" \
    && echo "error_reporting = E_ALL" >> "$PHP_INI_DIR/php.ini" \
    && echo "date.timezone = Europe/Paris" >> "$PHP_INI_DIR/php.ini" \
    && echo "error_log = /var/log/php/php_errors.log" >> "$PHP_INI_DIR/php.ini"

# VHOST
COPY ./default.conf /etc/apache2/sites-available/default.conf
COPY ./web.conf /etc/apache2/sites-available/web.conf

# Enable apache modules and sites
RUN a2enmod rewrite headers ssl
RUN a2ensite default.conf web.conf

# Cron
COPY ./cron /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

# Create folders
RUN mkdir -p /var/log/cron && mkdir -p /var/log/php

# UID & GID
RUN usermod -u $UID www-data && groupmod -g $GID www-data

# Run Cron & Apache
RUN sed -i 's/^exec /service cron start\n\nexec /' /usr/local/bin/apache2-foreground
