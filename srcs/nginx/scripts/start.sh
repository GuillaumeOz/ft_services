# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/11 17:15:09 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/11 17:16:27 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

adduser -D "$SSH_USER"
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

/usr/sbin/sshd
/usr/sbin/nginx -g 'daemon off;'