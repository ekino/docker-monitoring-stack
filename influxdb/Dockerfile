# --- INFLUXDB ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>
ENV DEBIAN_FRONTEND noninteractive
ENV INFLUXDB_VERSION 0.8.8

# required tools
RUN apt-get update
RUN apt-get install -y curl supervisor tcpdump

# install influxdb
RUN curl -sSL -o influxdb.deb https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb
RUN dpkg -i influxdb.deb
RUN rm influxdb.deb

RUN mkdir -p /usr/share/collectd
RUN curl -s https://raw.githubusercontent.com/collectd/collectd/master/src/types.db -o /usr/share/collectd/types.db

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/influxdb.conf
ADD config.toml /opt/influxdb/current/config.toml
ADD start.sh /start.sh

# http dashboard
EXPOSE 8083
# http api
EXPOSE 8086
# collectd binary protocol
EXPOSE 25826/udp

VOLUME ["/data"]

CMD ["/start.sh"]