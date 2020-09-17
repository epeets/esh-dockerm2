FROM php:7.3-fpm

# LABEL about the custom image
LABEL maintainer="Eschole Peets epeets@topspot.com"
LABEL version="0.1"
LABEL description="This is custom Docker Image for Magento 2 Installs."

# Define certain environment variable to help with bypass interactive installs
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America

# Install System Dependencies

RUN apt-get update \
	&& apt-get install -y apt-utils \
	software-properties-common \
	libapache2-mod-fcgid \
	curl \
	openssl \
	wget \
	git \
    libfreetype6-dev \ 
    libicu-dev \ 
    libmcrypt-dev \ 
    libpng-dev \ 
    libxslt1-dev \
	libpcre3 \
	libpcre3-dev \ 
    sudo \ 
    libzip-dev \ 
    libonig-dev \
	libjpeg-dev \ 
	htop \
	nginx

# Install PHP Extensions

RUN docker-php-ext-install \
	bcmath \
	ctype \
	dom \
	gd \
	iconv \
	intl \
	mbstring \ 
	simplexml \
	soap \
	xsl \
	zip \
	pdo_mysql \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr \
	&& docker-php-ext-install -j$(nproc) gd

# Install oAuth
RUN pecl install oauth \
	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# Setup Mailhog
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
   && mkdir /opt/go \
   && export GOPATH=/opt/go \
   && go get github.com/mailhog/mhsendmail

COPY "./mailhog.ini" "$PHP_INI_DIR/conf.d"

# Install Node, NVM, NPM and Grunt
RUN apt-get install -y nodejs \
	&& apt-get install -y npm \
	&& npm install -g grunt \
	&& npm install -g grunt-cli

# Install Composer
RUN	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
	&& mkdir /var/www/.composer \
	&& chmod -R 777 /var/www/.composer 

# Install Code Sniffer

RUN git clone https://github.com/magento/marketplace-eqp.git ~/.composer/vendor/magento/marketplace-eqp \
    && cd ~/.composer/vendor/magento/marketplace-eqp && composer install \ 
	&& ln -s ~/.composer/vendor/magento/marketplace-eqp/vendor/bin/phpcs /usr/local/bin;

# Install Magerun 2
RUN wget https://files.magerun.net/n98-magerun2.phar \
	&& chmod +x ./n98-magerun2.phar \
	&& mv ./n98-magerun2.phar /usr/local/bin/

# Permissions
RUN chsh -s /bin/bash www-data \
	&& chown -R 1000:www-data /var/www
RUN mkdir /var/www/magento2

EXPOSE 8080

VOLUME /var/www/magento2
WORKDIR /var/www/magento2