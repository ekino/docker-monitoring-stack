# --- GRAFANA ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND noninteractive
ENV GRAFANA_VERSION 1.9.1

# required tools
RUN apt-get update
RUN apt-get install -y curl supervisor collectd collectd-utils

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/collectd.conf
ADD collectd.conf /etc/collectd/collectd.conf
ADD start.sh /start.sh

CMD ["/start.sh"]
