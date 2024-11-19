FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    add-apt-repository -y ppa:ondrej/php


RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
    apt-get install -y \
    git \
    curl \
    openssh-client \
    ca-certificates \
    php8.3 \
    php8.3-bcmath \
    php8.3-ctype \
    php8.3-curl \
    php8.3-dom \
    php8.3-fpm \
    php8.3-gd \
    php8.3-intl \
    php8.3-mbstring \
    php8.3-mysqli \
    php8.3-opcache \
    php8.3-phar \
    php8.3-xml \
    php8.3-xmlreader \
    php8.3-pdo \
    php8.3-simplexml \
    php8.3-intl \
    php8.3-fileinfo \
    php8.3-tokenizer \
    php8.3-xmlwriter \
    php8.3-posix \
    php8.3-zip \
    supervisor \
    make

# install caddy
RUN apt install -y debian-keyring debian-archive-keyring apt-transport-https && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list && \
    apt update && \
    apt install caddy

COPY docker/Caddyfile /etc/caddy/Caddyfile

COPY docker/php-fpm.conf /etc/php/8.3/fpm/pool.d/www.conf
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# update PHP ini
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/g' /etc/php/8.3/fpm/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 22M/g' /etc/php/8.3/fpm/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php/8.3/fpm/php.ini

COPY ./ /var/www/app

### BACKEND

# install composer
RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && \
    php /tmp/composer-setup.php --install-dir=/usr/bin --filename=composer && \
    rm /tmp/composer-setup.php

# composer install
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --optimize-autoloader --no-dev --no-interaction --no-progress --working-dir=/var/www/app


# laravel directories
RUN touch /var/www/app/storage/logs/laravel.log
RUN chmod -R 777 /var/www/app/storage /var/www/app/bootstrap/cache

EXPOSE 80

CMD ["/usr/bin/supervisord"]
