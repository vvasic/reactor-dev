FROM php:7.4-fpm-buster

ENV NVM_VERSION=v0.35.3

RUN apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		build-essential \
		wget \
        unzip \
        bzip2 \
        libbz2-dev \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libwebp-dev \
		libgmp-dev \
		libxml2-dev \
		libcurl4-openssl-dev \
		libonig-dev \
		libzip-dev \
		ffmpeg \
		sudo \
		dumb-init \
	&& pecl install redis \
	&& docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg \
		--with-webp \
	&& docker-php-ext-install gd \
	 gmp \
	 pdo_mysql \
	 zip \
	 curl \
	 mbstring \
	 pcntl \
	 intl \
	 tokenizer \
	 xml \
	 bcmath \
	 exif \
	&& docker-php-ext-enable opcache exif redis \
    # install nvm
	&& curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/pear/

# install node 8 LTS and yarn
RUN	/bin/bash -ic "nvm install 8 --lts && nvm use 8 && npm install -g yarn"

# Install composer
WORKDIR /home/composer
COPY install_composer.php install_composer.php
RUN php install_composer.php \
    && composer global require hirak/prestissimo \
    && rm /home/composer/install_composer.php