#!/bin/sh

# Replace environment variables in nginx.conf
# shellcheck disable=SC2016
envsubst '${EVENTS},${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Start nginx
exec nginx -g 'daemon off;'