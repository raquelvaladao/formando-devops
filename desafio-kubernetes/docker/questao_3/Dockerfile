FROM debian

ENV NGINX_CONFIG_DIR="/etc/nginx"
RUN apt-get update && apt-get install nginx -y && apt-get clean

LABEL description="Web server"

COPY ./nginx-conf-template ${NGINX_CONFIG_DIR}

VOLUME [ "/var/www/html/" ]

EXPOSE 90

CMD ["nginx", "-g", "daemon off;"]
