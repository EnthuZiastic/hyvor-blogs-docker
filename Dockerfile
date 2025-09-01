FROM dunglas/frankenphp:1.4.4-php8.4.5-alpine AS frankenphp

WORKDIR /app
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
RUN apk update && apk add --no-cache supervisor curl && \
    install-php-extensions zip pcntl
COPY . /app

COPY docker/Caddyfile /etc/caddy/Caddyfile
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/run /app/run

RUN composer install --no-interaction --no-dev --optimize-autoloader --classmap-authoritative
RUN touch /app/storage/logs/laravel.log
RUN chmod -R 777 /app/storage /app/bootstrap/cache

EXPOSE 80
CMD ["/app/run"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD curl -f http://localhost/health || exit 1
