FROM dunglas/frankenphp:1.4.4-php8.4.5-alpine AS frankenphp

WORKDIR /app
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install Alpine-specific dependencies including python3 for supervisor
RUN apk update && apk add --no-cache \
    supervisor \
    python3 \
    py3-pip \
    curl \
    bash && \
    install-php-extensions zip pcntl opcache

# Create supervisor configuration directory (missing in Alpine by default)
RUN mkdir -p /etc/supervisor/conf.d && \
    mkdir -p /var/log/supervisor

# Configure PHP OPcache for optimal performance
RUN echo 'opcache.enable=1' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.enable_cli=1' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.memory_consumption=256' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.interned_strings_buffer=16' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.max_accelerated_files=10000' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.revalidate_freq=2' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.fast_shutdown=1' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.validate_timestamps=1' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.save_comments=1' >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo 'opcache.enable_file_override=1' >> /usr/local/etc/php/conf.d/opcache.ini

COPY . /app

COPY docker/Caddyfile /etc/caddy/Caddyfile
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/run /app/run

RUN composer install --no-interaction --no-dev --optimize-autoloader --classmap-authoritative
RUN touch /app/storage/logs/laravel.log
RUN chmod -R 777 /app/storage /app/bootstrap/cache

# Ensure run script is executable and create required runtime directories
RUN chmod +x /app/run && \
    mkdir -p /var/run /var/log/supervisor && \
    chmod 755 /var/run /var/log/supervisor

# Create a non-root user for better security (optional)
# RUN addgroup -g 1000 -S hyvor && \
#     adduser -u 1000 -D -S -G hyvor hyvor && \
#     chown -R hyvor:hyvor /app /var/log/supervisor

EXPOSE 80
CMD ["/app/run"]
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost/health || exit 1
