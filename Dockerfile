FROM php:5.6.36-fpm-alpine

RUN apk --no-cache add \
  supervisor \
  nginx \
  && rm -rf /var/cache/apk/*

RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/run/supervisor
RUN mkdir -p /run/nginx
RUN mkdir -p /var/www/html/public

RUN echo "<?php phpinfo();" >> /var/www/html/public/index.php

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf","--logfile", "/var/log/supervisor/supervisord.log","--pidfile", "/var/run/supervisor/supervisord.pid"]
