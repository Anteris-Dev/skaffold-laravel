FROM anterisdev/php-workspace:latest as builder
    WORKDIR /var/www/app

    COPY ./src/package* ./
    RUN npm install

    COPY ./src ./
    RUN composer install --optimize-autoloader --no-dev
    RUN npm run prod
    RUN rm -rf node_modules

FROM php:7.4-fpm-alpine

    # Install PHP-FPM Extensions, Nginx, and Supervisord
    RUN docker-php-ext-install bcmath opcache pdo_mysql \
        && apk add --no-cache nginx supervisor

    # Copy Configuration files
    # Start with things least likely to change
    COPY ./docker/supervisord/global/supervisord.conf /etc/supervisord.conf
    COPY ./docker/nginx/global/nginx.conf /etc/nginx/nginx.conf
    COPY ./docker/nginx/global/conf.d/* /etc/nginx/conf.d
    COPY ./docker/php-fpm/production/conf.d/* /usr/local/etc/php/conf.d

    # Copy Source Code
    COPY --from=builder --chown=www-data:www-data /var/www/app /var/www/app

    # Override Working Directory
    RUN rm -rf /var/www/html
    WORKDIR /var/www/app

    # Override Entrypoint
    COPY ./docker/docker-entrypoint.sh /usr/local/bin
    COPY ./docker/env-example /var/www/app/env-example
    ENTRYPOINT ["docker-entrypoint.sh"]

    # Add a new command
    CMD [ "/usr/bin/supervisord" , "-c", "/etc/supervisord.conf" ]
