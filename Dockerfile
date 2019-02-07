
FROM nginx:1.12.1

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    git curl vim libz-dev mysql-client ca-certificates less ;

## Setus up composer
#ENV COMPOSER_ALLOW_SUPERUSER=1

RUN mkdir -p /data/www-app/localhost ; \
    mkdir -p /data/apps/nginx/etc; \
    mkdir -p /data/apps/nginx/sites-enabled; \
    mkdir -p /data/ssl/certs; \
    mkdir -p /data/ssl/private; \
    mv /etc/nginx /etc/.nginx && ln -s /data/apps/nginx/etc /etc/nginx; \
    usermod -d /home/nginx -m nginx;

#RUN cd /usr/local/bin && curl --silent --show-error https://getcomposer.org/installer | php
WORKDIR /data/www-app
#COPY site.conf /etc/nginx/conf.d/

ADD ./nginx-conf/test-etc /data/apps/nginx/etc
#ADD ./nginx-conf/test-sites/ /data/apps/nginx/sites-enabled
ADD ./nginx-conf/test-etc /data/apps/nginx/etc
ADD ./nginx-conf/test-sites/ /data/apps/nginx/sites-enabled
ADD ./ssl/certs /data/ssl/certs
ADD ./ssl/private /data/ssl/private


RUN chmod -R +x /usr/local/bin; \
    chown  nginx /etc /data /run /usr; \
    chmod -R 0774 /tmp /var /run /etc /mnt /data/apps/nginx /data/www-app;\
    chown -R nginx:www-data /data/www-app; \
    chown -R nginx /data/apps/nginx /var /etc/nginx /usr/local /etc/alternatives /etc/ssl /tmp;\
    mkdir -p /home/nginx && chown -R nginx:nginx /home/nginx && chmod -R 0751 /home/nginx; \
    usermod -a -G www-data nginx

USER nginx

#ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
