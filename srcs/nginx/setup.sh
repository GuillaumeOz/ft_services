#!/bin/sh

adduser -D "$SSH_USER"
# update passwords for the new user
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

# sshd (OpenSSH Daemon) is the daemon program for ssh
# Together these programs replace rlogin and rsh, and provide secure
# encrypted communications between two untrusted hosts over an insecure network.
/usr/sbin/sshd
# For normal production (on a server), use the default daemon on;
# In this case for Docker containers (or for debugging), the daemon off;
/usr/sbin/nginx -g 'daemon off;'