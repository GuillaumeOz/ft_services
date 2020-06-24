# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/11 17:15:09 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/15 12:05:32 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

adduser -D "$SSH_USER"
# update passwords for the new user
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

# sshd (OpenSSH Daemon) is the daemon program for ssh
# Together these programs replace rlogin and rsh, and provide secure
# encrypted communications between two untrusted hosts over an insecure network.
/usr/sbin/sshd
# For normal production (on a server), use the default daemon on;
# In this case for Docker containers (or for debugging), the daemon off;
/usr/sbin/nginx -g 'daemon off;'