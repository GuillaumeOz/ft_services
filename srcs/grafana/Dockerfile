FROM grafana/grafana

COPY datasources.yml /etc/grafana/provisioning/datasources/
COPY dashboard.yml /etc/grafana/provisioning/dashboards/
COPY *.json /etc/grafana/provisioning/dashboards/

ENTRYPOINT [ "/run.sh" ]