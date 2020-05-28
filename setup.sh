# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/19 16:13:51 by gozsertt          #+#    #+#              #
#    Updated: 2020/05/28 16:57:58 by gozsertt         ###   ########.fr        #
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
	#kubectl apply - Apply or Update a resource from a file or stdin.
	# Create a service using the definition in example-service.yaml.
	kubectl apply -f srcs/$@.yaml > /dev/null
	echo -ne "$_GREEN➜$_YELLOW	Deploying $@...\n"
	sleep 2;
	# -l <clé-label>=<valeur-label> -o jsonpath=<modèle>
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	echo -ne "$_GREEN✓$_YELLOW	$@ deployed!\n"
}

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
#export MINIKUBE_HOME="/goinfre/$USER"# Its is necessary ?

