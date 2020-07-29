#!/bin/sh

#
# This block installs Laravel if it is not currently setup.
# If it is setup, it installs the vendor dependencies.
#
if [ ! "$(ls -A)" ]; then
    composer create-project laravel/laravel . --no-scripts --no-progress;
    composer run-script post-autoload-dump
elif [ -e composer.json ]; then
    composer install --no-progress
fi

#
# This block puts in our application environment file.
#
if [ ! -e .env ]; then
    mv /tmp/env-example /var/www/app/.env

    # We are setup, now run the Laravel scripts
    composer run-script post-root-package-install
    composer run-script post-create-project-cmd
fi;


#
# This block installs NPM dependencies if a package.json file is found
#
if [ -e package.json ]; then
    npm install
fi

exec "$@"
