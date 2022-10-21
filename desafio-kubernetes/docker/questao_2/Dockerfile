FROM debian

RUN apt-get update && apt-get install nginx -y && apt-get clean

LABEL description="Web server"

VOLUME [ "/var/www/html/" ]

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
