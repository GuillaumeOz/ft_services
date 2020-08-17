#!/bin/ash
nohup ./setup.sh > /dev/null 2>&1 &

mkdir -p /run/mysqld/

sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
/usr/bin/mysql_install_db --user=root --datadir="/var/lib/mysql"
# /usr/bin/mysqld_safe --datadir="/var/lib/mysql"
/usr/bin/mysqld --user=root --datadir="/var/lib/mysql"