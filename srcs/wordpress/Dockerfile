# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/06 17:42:29 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/08 18:33:25 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:latest

ENV APACHE_SERVER_PATH /var/www/localhost/htdocs
ENV VERSION_WORDPRESS 5.4.1

# Installing dependencies
RUN apk add --no-cache --virtual .build-deps unzip
RUN apk add --no-cache apache2 php7 php7-apache2 php7-openssl php7-xml php7-pdo php7-mcrypt php7-session php7-mysqli php7-zlib su-exec
RUN mkdir -p /run/apache2 /run/httpd

# Work path
WORKDIR /scripts

# Get and setup WordPress
ADD https://wordpress.org/${VERSION_WORDPRESS}.zip ./
RUN unzip -q wordpress-${VERSION_WORDPRESS}.zip -d ./ && \
        rm -rf ${APACHE_SERVER_PATH} && \
        mv wordpress/ ${APACHE_SERVER_PATH} && \
        rm /scripts/wordpress-${VERSION_WORDPRESS}.zip \
            ${APACHE_SERVER_PATH}/wp-config-sample.php \
            ${APACHE_SERVER_PATH}/license.txt \
            ${APACHE_SERVER_PATH}/readme.html && \
        chown -R apache:apache ${APACHE_SERVER_PATH} && \
        apk del .build-deps

# Copy of the HTTPD startup script
COPY scripts/start.sh start.sh
COPY files/wp-config.php ${APACHE_SERVER_PATH}/wp-config.php

EXPOSE 80

ENTRYPOINT [ "./start.sh" ]