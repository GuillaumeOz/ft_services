# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/22 17:14:20 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/27 11:38:21 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:latest

RUN apk add --no-cache vsftpd openssl

COPY files/pure-ftpd.pem /etc/ssl/private/
COPY scripts/start-tmp.sh /bin/start-tmp.sh

ENTRYPOINT ["/bin/start-tmp.sh"]