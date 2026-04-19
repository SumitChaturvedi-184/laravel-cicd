FROM php:8.4-fpm-alpine

WORKDIR /var/www/html

RUN apk add --no-cache \
    bash \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm \
    postgresql-dev

RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    gd \
    xml \
    bcmath \
    opcache

COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-interaction \
    --no-progress

RUN npm ci && npm run build && rm -rf node_modules

RUN chown -R www-data:www-data /var/www/html/storage \
    /var/www/html/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]