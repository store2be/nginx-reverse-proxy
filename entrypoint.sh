#!/bin/sh
set -e

# Set the default value of $PROXY_URL to production
PROXY_URL="${PROXY_URL:-missing}"
echo "Use \"$PROXY_URL\" for PROXY_URL"

sed -i -e 's|%PROXY_URL%|'$PROXY_URL'|g' /etc/nginx/conf.d/default.conf
sed -i -e 's|%PROXY_URL%|'$PROXY_URL'|g' /etc/nginx/conf.d/cached.conf
echo "Nginx configured with PROXY_URL \"$PROXY_URL\""

# Set the default value of $CACHE to false
CACHE="${CACHE:-false}"

if test "$CACHE" = "true"; then
  echo "Use a cache"
  # Delete the non cache config
  rm /etc/nginx/conf.d/default.conf
else
  echo "Don't use a cache"
  # Delete the cache config
  rm /etc/nginx/conf.d/cached.conf
fi

exec "$@"
