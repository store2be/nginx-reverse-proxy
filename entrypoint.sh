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

# Set the default value of $CACHE_IGNORE_QUERY_PARAMS to false
CACHE_IGNORE_QUERY_PARAMS="${CACHE_IGNORE_QUERY_PARAMS:-false}"

if test "$CACHE" = "true"; then
  echo "Use a cache"

  if test "$CACHE_IGNORE_QUERY_PARAMS" = "true"; then
    # Keep the line and consider query params in caching
    echo "Ignore query parameters in the cache key"
  else
    # The default behaviour, delete the line and consider query params in caching
    echo "[Default behaviour] Don't ignore query parameters in the cache key";
    sed -i -e 's|proxy_cache_key%||g' /etc/nginx/conf.d/cached.conf
  fi

  # Delete the non cache config
  rm /etc/nginx/conf.d/default.conf
else
  echo "Don't use a cache"
  # Delete the cache config
  rm /etc/nginx/conf.d/cached.conf
fi

exec "$@"
