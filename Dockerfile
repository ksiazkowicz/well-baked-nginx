FROM nginx:1.15

VOLUME /etc/letsencrypt

ADD root /
RUN rm /etc/nginx/conf.d/default.conf; \
    chmod +x /usr/local/bin/entrypoint.sh; \
    apt-get update && \
    apt-get -y install cron certbot gettext-base python-certbot-nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["entrypoint.sh"]