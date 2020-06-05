# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    testscript.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/27 09:36:09 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/05 14:53:53 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# USER=$(whoami)

_BLACK='\033[30m'
_RED='\033[31m'
_GREEN='\033[32m'
_YELLOW='\033[33m'
_BLUE='\033[34m'
_PURPLE='\033[35m'
_CYAN='\033[36m'
_WHITE='\033[37m'

MINIKUBE_IP=$(minikube ip)

# To point your shell to minikube's docker-daemon.
# eval — construct command by concatenating arguments
# -p, --profile string The name of the minikube VM being used. This can be set to allow having multiple instances of minikube independently. (default "minikube")
# docker-env Configure environment to use minikube’s Docker daemon
eval $(minikube -p minikube docker-env)

# MINIKUBE_IP EDIT

cp srcs/wordpress/files/wordpress.sql srcs/wordpress/files/wordpress-tmp.sql
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/wordpress/files/wordpress-tmp.sql
cp srcs/ftps/scripts/start.sh srcs/ftps/scripts/start-tmp.sh
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/ftps/scripts/start-tmp.sh

# Build Docker images

echo -ne "$_GREEN➜$_YELLOW	Building Docker images...\n"
docker build -t mysql_alpine srcs/mysql
docker build -t wordpress_alpine srcs/wordpress
docker build -t nginx_alpine srcs/nginx
docker build -t ftps_alpine srcs/ftps
docker build -t grafana_alpine srcs/grafana
echo -ne "$_GREEN✓$_YELLOW	$@ deployed!\n"
