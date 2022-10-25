FROM debian

ENV NGINX_CONFIG_DEFAULT="/etc/nginx/conf.d/"

RUN apt-get update && apt-get install nginx -y && apt-get clean

LABEL description="Web server"

VOLUME [ "${NGINX_CONFIG_DEFAULT}" ]

EXPOSE 90

CMD ["nginx", "-g", "daemon off;"]
