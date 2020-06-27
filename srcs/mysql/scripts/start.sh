# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/08 19:07:12 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/25 15:59:27 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!bin/sh

# Colors
_RED='\033[31m'
_GREEN='\033[32m'
_YELLOW='\033[33m'

# "mysqld" is MySQL server daemon program which runs quietly in background on 
# your computer system. Invoking "mysqld" will start the MySQL server on your system.
# Terminating "mysqld" will shutdown the MySQL server.

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	#chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo -ne "$_GREEN✓$_YELLOW MySQL directory already present, skipping creation\n"
else
	echo -ne "$_RED➜$_YELLOW MySQL data directory not found, creating initial DBs\n"

	# chown -R mysql:mysql /var/lib/mysql

	# init database
	# initializes the MariaDB data directory 
	# and creates the system tables in the mysql database
	echo -ne "$_GREEN➜$_YELLOW Initializing database\n"
	mysql_install_db --user=mysql > /dev/null
	echo -ne "$_GREEN✓$_YELLOW Database initialized\n"

	echo -ne "$_GREEN➜$_YELLOW MySql root password: $MYSQL_ROOT_PASSWORD \n"

	# create temp file
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi

	# save sql
	echo -ne "$_GREEN✓$_YELLOW Create temp file: $tfile \n"
	cat << EOF > $tfile
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
EOF

	echo 'FLUSH PRIVILEGES;' >> $tfile

	# run sql in tempfile
	echo -ne "$_GREEN➜$_YELLOW Run tempfile: $tfile"
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
	rm -f $tfile
fi

echo -ne "$_GREEN➜$_YELLOW Sleeping 5 sec\n"
sleep 5

echo -ne "$_GREEN➜$_YELLOW Start running mysqld\n"
exec /usr/bin/mysqld --user=mysql --console