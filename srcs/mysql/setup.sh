#! /bin/bash

# Wait that mysql was up
until mysql
do
	echo "NO_UP"
done

# Init DB
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "CREATE USER 'wp_admin'@'%' IDENTIFIED BY 'password';" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_admin'@'%' WITH GRANT OPTION;" | mysql -u root --skip-password
#echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "ALTER USER 'wp_admin'@'%' IDENTIFIED BY 'password';" | mysql -u root --skip-password
#echo "ALTER USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" | mysql -u root --skip-password
echo "DROP DATABASE test" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password
cat wordpress.sql | mysql wordpress -u root --skip-password