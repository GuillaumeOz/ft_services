# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/22 17:17:55 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/22 17:40:33 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh
mkdir -p /ftps/$FTP_USER

adduser -h /ftps/$FTP_USER -D $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

<<<<<<< HEAD
/usr/sbin/pure-ftpd -j -Y 2 -p 21000:21000 -P "192.168.99.105"
=======
/usr/sbin/pure-ftpd -j -Y 2 -p 21000:21000 -P "172.17.0.2"
>>>>>>> eff9ec5ba82128cfe7d30a5aabec04cb2cfb74db
