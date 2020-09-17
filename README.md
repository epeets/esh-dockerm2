# Docker for Magento 2.3+
This is full Docker setup for Magento 2 Development with Nginx, SSL, PHPMyAdmin, PHP 7.3, ElasticSearch 7, Grunt, Mailhog, Magerun 2


## How to install:

1. Clone this repo
2. Build the Dockerfile to setup your php image (this is called m2php in the docker-compose file but you can call it whatever you want)
3. Update the docker-compose with the name of php-fpm image you built in step 2
4. Update your confs/default.conf and dev.test.conf in the reverse-proxy folder for your chosen domain.
    1. Your are setup for *.dev.tests domains now (ex. magento.dev.tests) and if you don't want that you need to generate new SSL files in the devcerts/private folder for your chosen domain.
5. Update your hosts file and point 127.0.0.1 to your chosen domain
6. Run docker-compose up -d to set your container and pull down all the other neccassary images (phpmyadmin, elasticsearch, mailhog, etc)

That's it! You should be up and running.
