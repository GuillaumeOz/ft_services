FROM alpine:latest

# Install nginx and its dependencies
RUN apk update && apk add nginx \
&& apk add --no-cache --upgrade bash \
&& apk add openssl && mkdir -p var/run/nginx \
&& apk add openssl openssh \
&& rm -rf /var/cache/apk/*

#RUN NGINX
RUN mkdir -p /www
COPY ./index.html /www

# Create the file with the ssl key inside
RUN mkdir -p /etc/nginx/ssl && openssl req -newkey rsa:2048 -x509 -days 365 -nodes -keyout /etc/nginx/ssl/services.key -out /etc/nginx/ssl/services.pem -subj "/C=FR/ST=Paris/L=Paris/O=42, Inc./OU=IT/CN=ft_services"

RUN	usr/bin/ssh-keygen -A 
COPY	sshd_config /etc/ssh/

# Nginnx config
RUN rm /etc/nginx/nginx.conf
COPY ./nginx.conf /etc/nginx/nginx.conf

COPY setup.sh .

RUN chmod +x setup.sh

EXPOSE 80 443 22
CMD ./setup.sh
