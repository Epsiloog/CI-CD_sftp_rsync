# Utilisez l'image de base PHP 8.3
FROM mcr.microsoft.com/devcontainers/php:1-8.3

RUN apt-get update && apt-get install -y wget lftp rsync

# Installez les extensions PHP nécessaires
RUN docker-php-ext-install pdo pdo_mysql
