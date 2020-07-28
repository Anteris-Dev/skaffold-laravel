#!/bin/sh

if [ ! -f /var/www/app/.env ]; then
    cd /var/www/app
    mv env-example .env
    php artisan key:generate
fi

cd /var/www/app
php artisan optimize --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate

exec "$@"
