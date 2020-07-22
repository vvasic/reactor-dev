FROM php:7.4-fpm-buster

#skip deprecation warning for node 8
ENV NODE_NO_DEPRECATION 1
ENV NODE_NO_WARNINGS 1

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
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
		# install node and npm
		nodejs \
		npm \
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
	# install yarn
	&& npm install -g yarn \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/pear/

# Install composer
WORKDIR /home/composer
COPY install_composer.php install_composer.php
RUN php install_composer.php \
    && composer global require hirak/prestissimo \
    && rm /home/composer/install_composer.php