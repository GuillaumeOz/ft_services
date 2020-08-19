# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/19 16:13:51 by gozsertt          #+#    #+#              #
#    Updated: 2020/08/19 11:14:53 by gozsertt         ###   ########.fr        #
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

#---------------Variables Configuration----------------#

PACKAGES=""
SERVICE_LIST="nginx mysql wordpress phpmyadmin ftps influxdb telegraf grafana"
sed_list="srcs/telegraf/telegraf.conf"

# set -x

# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=`whoami`
# Set the minikube directory in current folder
# Enable this command if you run the projet at 42
# export MINIKUBE_HOME="/goinfre/$USER"
export sudo='';
export driver='docker'

#----------------Functions definition------------------#

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

sed_configs () {
    sed -i.bak 's/MINIKUBE_IP/'"$1"'/g' $2
    echo "configured $2 with $1"
    sleep 1
}

sed_configs_back () {
    sed -i.bak "s/$1/""MINIKUBE_IP"'/g' $2
    echo "deconfigured $2"
    sleep 1
}

build_apply () {
    docker build -t services/$1 srcs/$1
    sleep 1
    kubectl apply -f srcs/$1.yml
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
		kubectl delete -f srcs/$SERVICE.yml > /dev/null
	done
	kubectl delete -f srcs/metallb.yml > /dev/null
	kubectl delete -f srcs/metallbVM.yml > /dev/null
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

#-----------------------------42 or VM------------------------------#

if [[ $1 = '42mac' ]] ; then
	#------------------------42 PART-------------------------------#
    export driver='virtualbox'
    export MINIKUBE_HOME=/goinfre/${USER}/
    # Install and verify that docker is running
    docker-machine create default
    docker-machine start

	#----------------------Launch minikube--------------------------#
	$sudo minikube start --vm-driver=$driver  --bootstrapper=kubeadm

	if [[ $? == 0 ]]
	then
    	eval $($sudo minikube docker-env)
    	printf "Minikube started\n"
	else
    	$sudo minikube delete
    	printf "Error occured\n"
   		exit
	fi

	MINIKUBE_IP="$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)"

	for name in $sed_list
	do
    	sed_configs $MINIKUBE_IP $name
	done

	#----------------------Delete all pods--------------------------#
	kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl delete -f srcs/nginx.yml
	kubectl delete -f srcs/mysql.yml
	kubectl delete -f srcs/wordpress.yml
	kubectl delete -f srcs/phpmyadmin.yml
	kubectl delete -f srcs/ftps.yml
	kubectl delete -f srcs/grafana.yml
	kubectl delete -f srcs/influxdb.yml
	kubectl delete -f srcs/telegraf.yml

	#----------------------Install metallb--------------------------#
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

	kubectl apply -f srcs/metallb.yml
    sed_configs 192.168.99.127 srcs/ftps/scripts/start.sh
    sed_configs 192.168.99.125 srcs/mysql/wordpress.sql

	#----------------build images and apply deployments-------------#
	for service in $SERVICE_LIST
	do
   		build_apply $service
	done

	# File deconfiguration
	for name in $sed_list
	do
    	sed_configs_back $MINIKUBE_IP $name
	done

	# Start dashboard
	$sudo minikube dashboard &

fi
if [[ $1 = 'vm' ]] ; then
	#-------------------------VM PART-------------------------------#
    export sudo='sudo'
	$sudo usermod -aG sudo $USER > /dev/null

	#------------------------Update Packages------------------------#

	echo -ne "$_GREEN➜$_YELLOW Update Packages... \n"
	install_packages $sudo apt-get -y update
	echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"
	echo -ne "$_GREEN➜$_YELLOW Upgrade Packages... \n"
	install_packages $sudo apt-get -y dist-upgrade
	echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"

	#---------------------Install Docker--------------------------------#

	which docker > /dev/null
	if [[ $? != 0 ]] ; then
		echo -ne "$_GREEN➜$_YELLOW Install Docker... \n"
		PACKAGES="apt-get install docker-ce docker-ce-cli containerd.io"
		install_packages $PACKAGES
		$sudo groupadd docker
		$sudo usermod -a -G docker ${USER}
		newgrp docker
		echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"
	fi

	#---------------------Install Kubectl-------------------------------#

	$sudo rm -rf /usr/local/bin/kubectl
	echo -ne "$_GREEN➜$_YELLOW Install Kubectl... \n"
	PACKAGES="curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
	install_packages $PACKAGES
	chmod +x ./kubectl
	$sudo mv ./kubectl /usr/local/bin/kubectl
	echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"

	#---------------------Install Minikube------------------------------#

	$sudo rm -rf /usr/local/bin/minikube
	which minikube > /dev/null
	echo -ne "$_GREEN➜$_YELLOW Install Minikube... \n"
	PACKAGES="curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
	install_packages $PACKAGES
	chmod +x minikube
	$sudo cp minikube /usr/local/bin && rm minikube
	echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"

	#-------------------Start Minikube------------------#
	# Start the cluster if it's not running
	# What you’ll need 
	# 2 CPUs or more
	# Internet connection
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
		minikube start --vm-driver=$driver --bootstrapper=kubeadm

		if [[ $? != 0 ]]
		then
			$sudo minikube delete
    		echo -ne "$_GREEN➜$_YELLOW Error occured $_GREEN✓$_YELLOW \n"
    		exit
		fi

		# Enable or disable a minikube addon
		# Measuring Resource Usage

		# minikube addons enable metrics-server

		# Web interface for kubernetes

		# minikube addons enable metallb
		# minikube addons enable dashboard
	fi

	#-----------------Minkube Config-----------------#

	# To point your shell to minikube's docker-daemon.
	# eval — construct command by concatenating arguments
	# -p, --profile string The name of the minikube VM being used.
	# This can be set to allow having multiple instances of minikube independently. (default "minikube")
	# docker-env Configure environment to use minikube’s Docker daemon
	# set the environment variable with eval command
	eval $($sudo minikube docker-env)
	MINIKUBE_IP="$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)"
	# TELEGRAF EDIT .CONF FILE

	for name in $sed_list
	do
    	sed_configs $MINIKUBE_IP $name
	done

	#----------------------Delete all pods--------------------------#
	kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl delete -f srcs/nginx.yml
	kubectl delete -f srcs/mysql.yml
	kubectl delete -f srcs/wordpress.yml
	kubectl delete -f srcs/phpmyadmin.yml
	kubectl delete -f srcs/ftps.yml
	kubectl delete -f srcs/grafana.yml
	kubectl delete -f srcs/influxdb.yml
	kubectl delete -f srcs/telegraf.yml

	#----------------------Install metallb--------------------------#
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

	kubectl apply -f srcs/metallbVM.yml
    sed_configs 172.17.0.5 srcs/ftps/setup.sh
    sed_configs 172.17.0.3 srcs/mysql/wordpress.sql

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

	for SERVICE in $SERVICE_LIST
	do
		apply_yaml $SERVICE
	done

	# File deconfiguration
	for name in $sed_list
	do
  		sed_configs_back $MINIKUBE_IP $name
	done

	echo -ne "$_GREEN✓$_YELLOW	ft_services deployment complete !\n"
	echo -ne "$_GREEN➜$_YELLOW	You can access ft_services via this url: $MINIKUBE_IP\n"

	# Start dashboard
	$sudo minikube dashboard &

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
fi
