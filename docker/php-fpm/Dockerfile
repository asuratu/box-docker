FROM php:8.1-fpm

ARG CONTAINER_PACKAGE_URL

ENV DEBIAN_FRONTEND noninteractive

# CST zone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN sed -i "s@http://deb.debian.org@http://mirrors.ustc.edu.cn@g" /etc/apt/sources.list

RUN apt-get clean \
    && apt-get update \
    && apt-get install -y libmcrypt-dev libcurl4-openssl-dev libssl-dev zlib1g-dev libicu-dev g++ \
        libmagickwand-dev libmagickcore-dev pkg-config vim mcrypt zip unzip \
        iputils-ping redis-tools supervisor \
    && apt-get install -y git git-lfs \
    && git lfs install \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && apt-get install -y libonig-dev \
    && docker-php-ext-install mbstring \
    && apt-get install -y libzip-dev \
    && docker-php-ext-install zip bcmath intl opcache pdo_mysql pcntl

# ext redis
RUN pecl install redis \
    && docker-php-ext-enable redis

# ext swoole
RUN pecl install --configureoptions 'enable-sockets="no" enable-openssl="yes" enable-http2="yes" enable-mysqlnd="no" enable-swoole-json="yes" enable-swoole-curl="yes" enable-cares="no"' swoole \
    && docker-php-ext-enable swoole

# composer
RUN curl https://getcomposer.org/download/1.10.17/composer.phar -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# aliyun mirrors
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

WORKDIR /var/www/html
