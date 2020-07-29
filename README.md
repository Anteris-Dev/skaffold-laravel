# About this Package
This package makes it easy to get up and running with a Docker environment containing Laravel. It gives you the tools you need to begin developing and then build this into a Docker image for production.

* **Note:** While you have complete freedom to modify the Nginx configuration files, we assume that this application will be behind a proxy that handles SSL settings as opposed to that being something that directly effects this app. For this reason, SSL settings are not included by default.

# Requirements

- [Docker](https://www.docker.com/get-started)

# Getting Started

To being working with this project the following steps must be taken.

1. Run `composer create-project anteris-dev/skaffold-laravel` in your project directory. This will download the project files.
2. (Optional) If you have an existing Laravel project, create a directory labeled `src` and copy your project files into it. On startup, the container will install your composer and npm dependencies, but you will need to run any migrations or builds manually through the `workspace` container.
3. Run `docker-compose up -d` in your skaffold directory. If no Laravel files are found in the `src` directory, a new Laravel project will be created. This may take a few moments.
4. Go to `http://localhost` to view your Laravel website!

# Development Tips

* Use the `workspace` container to run any _artisan_, _composer_, or _npm_ commands.
  * You can access this container by running `docker-compose exec -it workspace sh` in your project directory.
  * Use `docker/docker-entrypoint-workspace.sh` to write any development setup commands (e.g. database migrations / seeding). By default this container installs composer and npm requirements.
* You can build a production container using the command `docker build .` in your project directory. Be sure to modify the configuration files if necessary!
* You can set environment variables via the `docker/env-example` file. We recommend you keep this file limited to containing `APP_NAME` and `APP_KEY`. Drive the rest through environment variables passed directly to the Docker container.

# Directory Structure

Despite our best efforts, the directory structure in this project is slightly complex. We believe this is a worthwhile trade-off, as it keeps things nicely tucked into their own sections. Each service has been given their own "domain" under the `docker` directory.

- .data - _This folder will be created automatically to persist your database._
- /docker
    - /nginx - _Contains Nginx specific configuration files._
        - /global - _Nginx configuration for all environments._
    - /php-fpm - _Contains PHP-FPM specific configuration files._
        - /development - _PHP-FPM configuration for development._
        - /production - _PHP-FPM configuration for production._
    - /supervisord - _Contains Supervisord configuration files._
        - /global - _Supervisord configuration for all environments._
    - docker-entrypoint.sh - _Entrypoint for the production container._
    - docker-entrypoint-workbench.sh - _Entrypoint for the workbench container. This would be a good place to write any setup commands for your dev environment (e.g. database migrations / seeding)._
    - env-example - _An env file that will be copied into the container on startup._
- /src - _This directory gets created automatically and is yours directory to play with. Laravel gets installed here._
- docker-compose.yaml - _This file allows you to quickly spin up a development environment on your machine._
- Dockerfile - _The production image for this application._
- Dockerfile.dev - _A development image that runs PHP and Nginx._
- Dockerfile.workspace - _A development image that contains PHP CLI and NPM so you may run your console commands._
