#!/bin/sh

if [ ! -f /var/www/app/.env ]; then
    mv env-example .env
    php artisan key:generate
fi

php artisan optimize
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force

exec "$@"
