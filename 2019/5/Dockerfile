FROM eu.gcr.io/vseth-public/php7:delta

WORKDIR /app/var/htdocs/

COPY nginx.conf /etc/nginx/sites-enabled/default

COPY www.conf /app/var/fpm-pools.d/

COPY index.php input.txt /app/var/htdocs/

RUN chown -R www-data:www-data .

EXPOSE 80