# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/19 16:13:51 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/03 19:35:47 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#-----------------------Install Brew------------------------------#

# Brew is installed ? : (if its neccessary... then redo this part)
# 	- no : Install it
# 	- yes : Check for update
# which brew > /dev/null
# if [[ $? != 0 ]] ; then
#     echo -ne "\033[1;31m+>\033[0;33m Install brew... \n"
#     rm -rf $HOME/.brew && git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew && export PATH=$HOME/.brew/bin:$PATH && brew update && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.zshrc &> /dev/null
# else
# 	echo -ne "\033[1;32m+>\033[0;33m Update brew... ! \n"
#     brew update &> /dev/null
# fi

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Colors
_BLACK='\033[30m'
_RED='\033[31m'
_GREEN='\033[32m'
_YELLOW='\033[33m'
_BLUE='\033[34m'
_PURPLE='\033[35m'
_CYAN='\033[36m'
_WHITE='\033[37m'

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
	kubectl delete -f srcs/ingress.yaml > /dev/null
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

# TODO
# Enable Sudo mode for all commands.

#---------------------Virtualisation Mode---------------------------#
# Checking if te virtualisation is on for minikube || check if its work on the vm without this ||
grep -Eq 'vmx|svm' /proc/cpuinfo
if [ $? != 0 ]; then
	echo -ne "$_RED➜$_WHITE Please activate the virtualisation on your Virtual Machine and restart the script.\n"
	exit
fi

#----------------------------Sudo Mode------------------------------#
sudo usermod -aG sudo $USER > /dev/null #Check is there are any probs on VM

# if [[ $? != 0 ]] ; then
# 	echo -ne "$_RED➜$_YELLOW Insecure completion-dependent directories detected: \n"
# 	echo -ne "$_GREEN➜$_YELLOW Fixing your permissions... \n"
# 	compaudit | xargs chmod g-w,o-w
# 	sudo -s > /dev/null
# 	if [[ $? != 0 ]] ; then
# 		echo -ne "$_RED➜$_YELLOW We cannot load your permissions from these directories: \n"
# 		sudo -s | grep "$USER"
# 		echo -ne "\n$_RED➜$_YELLOW Please fix your permissions and restart the script.\n"
# 		exit
# 	echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"
# fi

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

#------------------Install Minikube------------------------------#

which minikube > /dev/null
if [[ $? != 0 ]] ; then
	echo -ne "$_GREEN➜$_YELLOW Install Minikube... \n"
	PACKAGES="curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
	install_packages $PACKAGES
	chmod +x minikube
	sudo mkdir -p /usr/local/bin/
	sudo install minikube /usr/local/bin/
	echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"
fi

#------------------Install Kubectl------------------#

kubectl version --client > /dev/null
if [[ $? != 0 ]] ; then
	echo -ne "$_GREEN➜$_YELLOW Install Kubectl... \n"
	PACKAGES="curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl"
	install_packages $PACKAGES
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl
	sudo install minikube /usr/local/bin/
	echo -ne "$_GREEN➜$_YELLOW Done $_GREEN✓$_YELLOW \n"
fi

#-----------------Env Configuration-----------------#
# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=`whoami`
[ -z "${WORKDIR}" ] && WORKDIR=`pwd`
mkdir -p $WORKDIR/$USER
# Set the minikube directory in current folder
# export MINIKUBE_HOME="/goinfre/$USER"# Its is necessary ?

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
	minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
	# Enable or disable a minikube addon
	# Measuring Resource Usage
	minikube addons enable metrics-server
	minikube addons enable ingress
	# Web interface for kubernetes
	minikube addons enable dashboard
fi

MINIKUBE_IP=$(minikube ip)

# To point your shell to minikube's docker-daemon.
# -p, --profile string The name of the minikube VM being used. This can be set to allow having multiple instances of minikube independently. (default "minikube")
eval $(minikube -p minikube docker-env)