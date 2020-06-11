# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    2testscript.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/09 14:12:44 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/09 15:25:32 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Colors
_RED='\033[31m'
_GREEN='\033[32m'
_YELLOW='\033[33m'

tfile=`mktemp`
printf "$tfile"
cat << EOF > $tfile
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
EOF
echo 'FLUSH PRIVILEGES;' >> $tfile
cat $tfile