FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    git \
    libzip-dev \
    libpng-dev

RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip

RUN a2enmod rewrite

COPY . /var/www/html

WORKDIR /var/www/html

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN chown -R www-data:www-data \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]

