#!/bin/bash

sed -i 's,INFLUXDB_HOST,'${INFLUXDB_HOST:-"127.0.0.1"}',' /etc/collectd/collectd.conf
sed -i 's,INFLUXDB_PORT,'${INFLUXDB_PORT:-"25826"}',' /etc/collectd/collectd.conf

# Start server
supervisord -n
