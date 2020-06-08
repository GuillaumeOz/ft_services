# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/08 18:35:08 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/08 19:04:51 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:latest

RUN apk update && \
	apk add mysql mysql-client && \
	addgroup mysql mysql && \
	rm -rf /var/cache/apk/*

COPY scripts/start.sh /bin/start.sh
COPY files/my.cnf /etc/mysql/my.cnf

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["/bin/start.sh"]