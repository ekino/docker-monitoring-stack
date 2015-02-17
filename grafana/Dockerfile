# --- GRAFANA ---

FROM ekino/base
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV GRAFANA_VERSION 1.9.1

# required tools
RUN apt-get update && apt-get install -y python-twisted

# install grafana
RUN curl -sSL -o grafana.tar.gz http://grafanarel.s3.amazonaws.com/grafana-${GRAFANA_VERSION}.tar.gz
RUN mkdir -p /opt
RUN tar xzf grafana.tar.gz -C /opt
RUN ln -sf /opt/grafana-${GRAFANA_VERSION} /opt/grafana
RUN rm -f grafana.tar.gz

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/grafana.conf
ADD config.js /opt/grafana/config.js
ADD ekino-sample-dashboard.json /opt/grafana/app/dashboards/default.json
ADD logo-ekino.png /opt/grafana/img/logo-ekino.png

EXPOSE 8080

# startup
ADD grafana.sh /start.d/15.grafana
