FROM php:8.2-apache

RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN a2enmod rewrite

COPY . /var/www/html/
RUN ln -s /var/www/html /var/www/html/sigeru

RUN mkdir -p /var/lib/php/sessions \
    && chown -R www-data:www-data /var/www/html /var/lib/php/sessions

EXPOSE 80
