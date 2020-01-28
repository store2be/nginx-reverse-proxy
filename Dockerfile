FROM nginx:1.15-alpine

RUN apk update && apk upgrade

COPY esh /esh
COPY nginx.main.conf /etc/nginx/nginx.conf
COPY nginx.proxy.conf.esh /etc/nginx/conf.d/default.conf.esh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN chmod +x /esh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
