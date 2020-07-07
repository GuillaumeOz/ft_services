# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/19 16:13:51 by gozsertt          #+#    #+#              #
#    Updated: 2020/07/06 20:49:34 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Colors
_BLACK='\033[30m'
_RED='\033[31m'
_GREEN='\033[32m'
_YELLOW='\033[33m'
_BLUE='\033[34m'
_PURPLE='\033[35m'
_CYAN='\033[36m'
_WHITE='\033[37m'
_NOCOLOR='\033[0m'

# Variables

PACKAGES=""
SERVICE_LIST="mysql phpmyadmin nginx wordpress ftps influxdb grafana telegraf"

# Functions

function install_packages()
{
	echo -ne "$_BLUE
	╔══════════════════════╗
	║██████                ║  (33%)
	╚══════════════════════╝\n"
	sleep 1
	echo -ne "$_BLUE
	╔══════════════════════╗
	║███████████████       ║  (66%)
	╚══════════════════════╝\n"
	sleep 1
	$@ &> /dev/null
	echo -ne "$_BLUE
	╔══════════════════════╗
	║██████████████████████║  (100%)
	╚══════════════════════╝\n"
}

function apply_yaml()
{
	# kubectl apply - Apply or Update a resource from a file or stdin.
	# Create a service using the definition in example-service.yaml.
	kubectl apply -f srcs/$@.yaml > /dev/null
	echo -ne "$_GREEN➜$_YELLOW	Deploying $@...\n"
	echo -ne "$_NOCOLOR"
	sleep 2;
	# kubectl [command] [TYPE] [NAME] [flags]
	# [command] = get
	# [TYPE] = pods
	# [NAME] = Omitted, here details for all resources are displayed for 'kubectl get pods'
	# [flags1] = -l <clé-label>=<valeur-label>
	# [flags2] = -o or --output jsonpath=<modèle> 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' >> check fomatting output
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	echo -ne "$_GREEN✓$_YELLOW	$@ deployed!\n"
}

if [[ $1 = 'clean' ]] ; then
	echo -ne "$_GREEN➜$_YELLOW	Cleaning all services...\n"
	for SERVICE in $SERVICE_LIST ; do
	# Delete a pod using the type and name specified in the pod.yaml file.
		kubectl delete -f srcs/$SERVICE.yaml > /dev/null
	done
	kubectl delete -f srcs/metallb.yaml > /dev/null
	echo -ne "$_GREEN✓$_YELLOW	Clean complete !\n"
	exit
fi

echo -e 	"\n\n $_WHITE
███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
																	 (by gozsertt)
																				  \n\n"
sleep 0.5

#---------------------Virtualisation Mode---------------------------#
# Checking if te virtualisation is on for minikube
# Activate this part if necessary
# If you run the flags --driver=docker within a VM, virtualization is not necessery

# grep -Eq 'vmx|svm' /proc/cpuinfo
# if [ $? != 0 ]; then
# 	echo -ne "$_RED➜$_WHITE Please activate the virtualisation on your Virtual Machine and restart the script.\n"
# 	exit
# fi

#----------------------------Sudo Mode------------------------------#

sudo usermod -aG sudo $USER > /dev/null

#------------------------Update Packages----------------------------#

echo -ne "$_GREEN➜$_YELLOW Update Packages... \n"
install_packages sudo apt-get -y update
echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"
echo -ne "$_GREEN➜$_YELLOW Upgrade Packages... \n"
install_packages sudo apt-get -y dist-upgrade
echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"

#---------------------Install Docker--------------------------------#

which docker > /dev/null
if [[ $? != 0 ]] ; then
	echo -ne "$_GREEN➜$_YELLOW Install Docker... \n"
	PACKAGES="apt-get install docker-ce docker-ce-cli containerd.io"
	install_packages $PACKAGES
	echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"
fi

#------------------Install Kubectl------------------#

sudo rm -rf /usr/local/bin/kubectl
echo -ne "$_GREEN➜$_YELLOW Install Kubectl... \n"
PACKAGES="curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
install_packages $PACKAGES
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"

#------------------Install Minikube------------------------------#

sudo rm -rf /usr/local/bin/minikube
which minikube > /dev/null
echo -ne "$_GREEN➜$_YELLOW Install Minikube... \n"
PACKAGES="curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
install_packages $PACKAGES
chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube
echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"

#-----------------Env Configuration-----------------#
# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=`whoami`
[ -z "${WORKDIR}" ] && WORKDIR=`pwd`
# Set the minikube directory in current folder
# Enable this command if you run the projet at 42
# export MINIKUBE_HOME="/goinfre/$USER"

#-------------------Start Minikube------------------#
# Start the cluster if it's not running
# What you’ll need 
# 2 CPUs or more
# 2GB of free memory
# 20GB of free disk space
# Internet connection
# Container or VirtualBox
if [[ $(minikube status | grep -c "Running") == 0 ]] ; then
	# Starts a local Kubernetes cluster
	# --cpus [int] Number of CPUs allocated to Kubernetes. (default 2)
	# --memory [string] Amount of RAM to allocate to Kubernetes (format: <number>[<unit>], where unit = b, k, m or g).
	# --vm-driver driver DEPRECATED, use driver instead.
	# --extra-config ExtraOption A set of key=value pairs that describe configuration that may be passed to different components.
    # The key should be '.' separated, and the first part before the dot is the component to apply the configuration to.
    # Valid components are: kubelet, kubeadm, apiserver, controller-manager, etcd, proxy, scheduler
    # Valid kubeadm parameters: ignore-preflight-errors, dry-run, kubeconfig, kubeconfig-dir, node-name, cri-socket, experimental-upload-certs, certificate-key, rootfs, skip-phases, pod-network-cidr
	# If you set the type field to NodePort, the Kubernetes control plane allocates a port from a range specified by the --service-node-port-range flag (default: 30000-32767).
	# DEBUG : Use minikube start --alsologtostderr -v=7 (for VirtualBox Driver), --alsologtostderr -v=1 (for Docker Driver)
	# Note for minikube start --vm-driver=none run -> apt-get install -y conntrack for fix the issus
	minikube start --cpus=2 --memory 4000 --driver=docker --extra-config=apiserver.service-node-port-range=1-35000
	# Enable or disable a minikube addon
	# Measuring Resource Usage
	minikube addons enable metrics-server
	# Web interface for kubernetes
	minikube addons enable metallb
	minikube addons enable dashboard
fi

#-----------------Minkube Config-----------------#

MINIKUBE_IP=$(minikube ip)

# To point your shell to minikube's docker-daemon.
# eval — construct command by concatenating arguments
# -p, --profile string The name of the minikube VM being used.
# This can be set to allow having multiple instances of minikube independently. (default "minikube")
# docker-env Configure environment to use minikube’s Docker daemon
# set the environment variable with eval command
eval $(minikube -p minikube docker-env)

# MINIKUBE_IP EDIT IN WORDPRESS SQL

cp srcs/wordpress/files/wordpress.sql srcs/wordpress/files/wordpress-tmp.sql
sed -i "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/wordpress/files/wordpress-tmp.sql
cp srcs/ftps/scripts/start.sh srcs/ftps/scripts/start-tmp.sh
sed -i "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/ftps/scripts/start-tmp.sh

# Build Docker images

echo -ne "$_GREEN➜$_YELLOW Building Docker images...\n"
docker build -t mysql_alpine srcs/mysql
docker build -t wordpress_alpine srcs/wordpress
docker build -t nginx_alpine srcs/nginx
docker build -t ftps_alpine srcs/ftps
docker build -t grafana_alpine srcs/grafana
echo -ne "$_GREEN✓$_YELLOW Deployed !\n"

# Deploy services

echo -ne "$_GREEN✓$_YELLOW Deploying services...\n"
echo -ne "$_NOCOLOR"

kubectl apply -f srcs/metallb.yaml > /dev/null

for SERVICE in $SERVICE_LIST
do
	apply_yaml $SERVICE
done

# Import Wordpress database
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql -u root -e 'CREATE DATABASE wordpress;'
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/wordpress/files/wordpress-tmp.sql

# Remove TMP files
rm -rf srcs/ftps/scripts/start-tmp.sh
rm -rf srcs/wordpress/files/wordpress-tmp.sql

echo -ne "$_GREEN✓$_YELLOW	ft_services deployment complete !\n"
echo -ne "$_GREEN➜$_YELLOW	You can access ft_services via this url: $MINIKUBE_IP\n"

### Launch Dashboard
# minikube dashboard

### Test SSH
# ssh admin@$(minikube ip) -p 22

### Crash Container
# kubectl exec -it $(kubectl get pods | grep mysql | cut -d" " -f1) -- /bin/sh -c "kill 1"

### Export/Import Files from containers
# kubectl cp srcs/grafana/grafana.db default/$(kubectl get pods | grep grafana | cut -d" " -f1):/var/lib/grafana/grafana.db

# ENV
# Alpine Linux

# API
# 1 - Nginx
# 2 - FTPS
# 3 - WordPress
# 4 - phpMyAdmin
# 5 - MariaDB (MySQL)
# 6 - Grafana
#     InfluxDB
#     Telegraf
