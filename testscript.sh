# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    testscript.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/27 09:36:09 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/06 14:55:34 by gozsertt         ###   ########.fr        #
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

# Deploy services

printf "$_GREEN✓$_YELLOW	Deploying services...\n"

for SERVICE in $SERVICE_LIST
do
	apply_yaml $SERVICE
done

kubectl apply -f srcs/ingress.yaml > /dev/null

# Import Wordpress database
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql -u root -e 'CREATE DATABASE wordpress;'
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/wordpress/files/wordpress-tmp.sql

# Remove TMP files
rm -rf srcs/ftps/scripts/start-tmp.sh
rm -rf srcs/wordpress/files/wordpress-tmp.sql

printf "$_GREEN✓$_YELLOW	ft_services deployment complete !\n"
printf "$_GREEN➜$_YELLOW	You can access ft_services via this url: $MINIKUBE_IP\n"

### Launch Dashboard
# minikube dashboard

### Test SSH
# ssh admin@$(minikube ip) -p 4000

### Crash Container
# kubectl exec -it $(kubectl get pods | grep mysql | cut -d" " -f1) -- /bin/sh -c "kill 1"

### Export/Import Files from containers
# kubectl cp srcs/grafana/grafana.db default/$(kubectl get pods | grep grafana | cut -d" " -f1):/var/lib/grafana/grafana.db