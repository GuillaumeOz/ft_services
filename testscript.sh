# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    testscript.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/27 09:36:09 by gozsertt          #+#    #+#              #
#    Updated: 2020/05/29 12:51:02 by gozsertt         ###   ########.fr        #
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

SERVICE_LIST="mysql phpmyadmin nginx wordpress ftps influxdb grafana telegraf"

if [[ $1 = 'clean' ]] ; then
	echo -ne "$_GREEN➜$_YELLOW	Cleaning all services...\n"
	for SERVICE in $SERVICE_LIST ; do
	# Delete a pod using the type and name specified in the pod.yaml file.
		echo "-1-\n"
	done
	echo "-2-\n"
	echo -ne "$_GREEN✓$_YELLOW	Clean complete !\n"
	exit
fi
