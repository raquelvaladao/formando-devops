FROM debian

ENV NGINX_CONFIG_DEFAULT="/etc/nginx/conf.d/default.conf"

RUN apt-get update && apt-get install nginx -y && apt-get clean

LABEL description="Web server"

COPY ./nginx-template.conf ${NGINX_CONFIG_DEFAULT}

VOLUME [ "/var/www/html/" ]

EXPOSE 90

RUN chmod 0400 ${NGINX_CONFIG_DEFAULT}

CMD ["nginx", "-g", "daemon off;"]
