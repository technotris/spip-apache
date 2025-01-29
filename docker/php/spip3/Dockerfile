#syntax=docker/dockerfile:1.4
# Versions
FROM php:5.6-apache AS spip_php

ENV APP_ENV=dev
WORKDIR /app
# stretch not maintained anymore: moved to archive
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN set -eux; \
	apt-get update; \
	apt-get install -y libicu-dev zlib1g-dev libgd-dev libcurl4-openssl-dev libxml2-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp;
RUN docker-php-ext-configure gd;
# dom for phpunit
RUN docker-php-ext-install intl opcache zip curl xml gd mysqli dom;
RUN docker-php-ext-enable xml curl gd mysqli opcache zip;

RUN set -eux; a2enmod rewrite expires headers; 
#TO CHANGE
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /var/www/html

CMD ["apache2-foreground"]

#USER www-data

#change SENDMAIL FOR DEV purpose msmtp
FROM spip_php AS spip_php_dev
ENV APP_ENV=dev
RUN set -eux; apt-get install -y msmtp;
# option t to read the "to" and read-envelope-from for the "from" in headers
RUN echo "sendmail_path = '/usr/bin/msmtp -t --host=mailer --port=1025 --read-envelope-from'" >> /usr/local/etc/php/conf.d/php-sendmail.ini
RUN echo "sendmail_from = test@spip.net" >> /usr/local/etc/php/conf.d/php-sendmail.ini

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data