# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/19 16:13:51 by gozsertt          #+#    #+#              #
#    Updated: 2020/05/27 16:32:44 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

#-----------------------Install Brew------------------------------#

# Brew is installed ? : (if its neccessary... then redo this part)
# 	- no : Install it
# 	- yes : Check for update
which brew > /dev/null
if [[ $? != 0 ]] ; then
    echo -ne "\033[1;31m+>\033[0;33m Install brew... \n"
    rm -rf $HOME/.brew && git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew && export PATH=$HOME/.brew/bin:$PATH && brew update && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.zshrc &> /dev/null
else
	echo -ne "\033[1;32m+>\033[0;33m Update brew... ! \n"
    brew update &> /dev/null
fi

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
	╚══════════════════════╝"
	sleep 1
	$@ > /dev/null
	echo -ne "$_BLUE
	╔══════════════════════╗
	║██████████████████████║  (100%)
	╚══════════════════════╝\n"
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
# Check && Install Docker, minikube and kubectl. Done, check if its ok.
# Enable Sudo mode for all commands.

# Checking if te virtualisation is on for minikube || check if its work on the vm without this ||
grep -Eq 'vmx|svm' /proc/cpuinfo
if [ $? != 0 ]; then
   echo 'Please activate the virtualisation on your Virtual Machine and restart the script'
   exit
fi

#-----------------------Update Packages---------------------------#
echo -ne "$_GREEN➜$_YELLOW Update Packages... \n"
install_packages sudo apt-get -y update
echo -ne "$_GREEN➜$_YELLOW Upgrade Packages... \n"
install_packages sudo apt-get -y dist-upgrade

#-------------------Install Docker-------------------------------#
which docker > /dev/null
if [[ $? != 0 ]] ; then
    echo -ne "$_GREEN➜$_YELLOW Install Docker... \n"
	PACKAGES="apt-get install docker-ce docker-ce-cli containerd.io"
	install_packages $PACKAGES
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
fi
