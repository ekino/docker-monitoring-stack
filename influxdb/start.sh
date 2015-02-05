#!/bin/bash

set -x

exec /usr/bin/influxdb -config /opt/influxdb/current/config.toml &

timeout=10
API="http://localhost:8086"
while true
do
  curl -s $API/ping && break
  echo "==> InfluxDB not yet started (waiting ${timeout}s...)"
  sleep $timeout
done
echo "==> InfluxDB is started. Proceeding."

DATABASES=${DATABASES:-defaultdb,sampledb}
IFS=','
for db in $DATABASES
do
  echo "==> Creating $db"
  DATA="{\"name\":\"${db}\"}"
  URL="${API}/db?u=root&p=root"
  curl -sk -X POST -d $DATA $URL
done

kill -9 $(ps aux | grep influxdb | grep -v grep | awk '{print $2}' | head -1)

# Start server
supervisord -n
