# well-baked-nginx
Welcome to the well-baked-nginx, a Docker image filled with some sweet stuffing and well baked.


## What is well-baked-nginx?
It's a Docker image based on official NGINX image from Docker Hub. It has a couple of cool features.
- sane defaults which you can customize by setting some environment variables,
- shipped with up to date version of Certbot and certbot-nginx plugin,
- a script that makes it all possible.

## Environment variables
All environment variables are optional.

- `USE_LETSENCRYPT` - if set to `1`, LetsEncrypt cron job and nginx config will be enabled,
- `APP_SERVER_NAME` (default: `localhost`) - server name under which app is available. If someone tries to access the host with a HTTP Host Header different than `APP_SERVER_NAME`, access will be denied.
- `APP_HTTP_USERNAME` and `APP_HTTP_PASSWORD` - if both are provided, Basic Authentication will be enabled with these credentials.
- `SSL_PEM_PATH` and `SSL_KEY_PATH` - paths to SSL certificates, if `USE_LETSENCRYPT` is set to `1`, will be automatically set to something that makes sense.
- `API_URL` - if NGINX is acting as a proxy for an API, you can pass the URL as an environment variable.

## Default config and how to replace it?
By default NGINX will serve files from `/var/www`. You can copy `root/etc/nginx/conf.d/default.conf.template` and modify it for your own usage.
