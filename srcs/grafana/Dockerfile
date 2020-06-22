# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gozsertt <gozsertt@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/22 17:41:52 by gozsertt          #+#    #+#              #
#    Updated: 2020/06/22 17:49:53 by gozsertt         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM grafana/grafana

COPY datasources.yml /etc/grafana/provisioning/datasources/
COPY dashboard.yml /etc/grafana/provisioning/dashboards/
COPY *.json /etc/grafana/provisioning/dashboards/

ENTRYPOINT [ "/run.sh" ]