#!/bin/sh
set -e

./esh -o /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.esh

exec "$@"
