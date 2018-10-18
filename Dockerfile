FROM php:7.2-fpm-alpine

RUN apk --no-cache add \
  supervisor \
  nginx \
  freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
  zlib-dev \
  php7-zip \
  && docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
  && docker-php-ext-install -j${NPROC} gd mysqli pdo pdo_mysql zip \
  && rm -rf /var/cache/apk/* \
  && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/run/supervisor
RUN mkdir -p /run/nginx
RUN mkdir -p /var/www/html/public

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf","--logfile", "/var/log/supervisor/supervisord.log","--pidfile", "/var/run/supervisor/supervisord.pid"]
