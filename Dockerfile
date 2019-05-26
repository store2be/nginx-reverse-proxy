FROM nginx:1.15-alpine

COPY nginx.main.conf /etc/nginx/nginx.conf
COPY nginx.proxy.conf /etc/nginx/conf.d/default.conf
COPY nginx.proxy-cached.conf /etc/nginx/conf.d/cached.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
