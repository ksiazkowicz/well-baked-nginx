#!/usr/bin/env sh
export APP_SERVER_NAME=${APP_SERVER_NAME:-localhost}

if [ -n "$APP_HTTP_USERNAME" ] && [ -n "$APP_HTTP_PASSWORD" ]; then
    htpasswd -b -c /etc/nginx/.htpasswd $APP_HTTP_USERNAME $APP_HTTP_PASSWORD
    export APP_AUTH_BASIC="\"Restricted Content\""
else
    touch /etc/nginx/.htpasswd
    export APP_AUTH_BASIC="off"
fi

if [ $USE_LETSENCRYPT=1 ]; then
    export SSL_PEM_PATH=/etc/letsencrypt/live/$APP_SERVER_NAME/fullchain.pem
    export SSL_KEY_PATH=/etc/letsencrypt/live/$APP_SERVER_NAME/privkey.pem
    crontab /etc/cron.d/letsencrypt
else
    export SSL_PEM_PATH=${SSL_PEM_PATH:-/etc/nginx/certs/cert.pem}
    export SSL_KEY_PATH=${SSL_KEY_PATH:-/etc/nginx/certs/cert.key}
fi

if [ -f "$SSL_PEM_PATH" ] && [ -f "$SSL_KEY_PATH" ]; then
    export PROTOCOL="443 ssl"
    envsubst '$$APP_SERVER_NAME $$SSL_PEM_PATH $$SSL_KEY_PATH' < /etc/nginx/ssl.conf.template > /etc/nginx/conf.d/ssl.conf
    if [ $USE_LETSENCRYPT=1 ]; then
        echo include /etc/letsencrypt/options-ssl-nginx.conf >> /etc/nginx/conf.d/ssl.conf
        echo ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem >> /etc/nginx/conf.d/ssl.conf
    else
        echo include /etc/nginx/options-ssl.nginx.conf >> /etc/nginx/conf.d/ssl.conf
    fi
else
    export PROTOCOL="80"
    echo "Disabled SSL because certificate does not exist"
fi

envsubst '$$APP_SERVER_NAME $$API_URL $$APP_AUTH_BASIC $$PROTOCOL' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

cron
nginx -g 'daemon off;'