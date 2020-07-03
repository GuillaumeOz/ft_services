#!/bin/sh
mkdir -p /ftps/$FTP_USER

adduser -h /ftps/$FTP_USER -D $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

/usr/sbin/pure-ftpd -j -Y 2 -p 21000:21000 -P "172.17.0.3"