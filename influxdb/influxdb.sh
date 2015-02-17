#!/bin/bash
#set -x

echo "$green ==> Starting ekino/influxdb:base$reset"

/usr/bin/influxdb -config /opt/influxdb/current/config.toml &
pid="$!"

timeout=10
API="http://localhost:8086"
while true
do
  curl -s $API/ping && break
  echo "$cyan --> InfluxDB not yet started (waiting ${timeout}s)"
  sleep $timeout
  # stop after Nth attempt ?
done
echo "$cyan --> Influxdb is started. Proceeding...$reset"

echo "$cyan --> Setting influxdb database$reset"

DATABASES=${DATABASES:-defaultdb,sampledb}
IFS=','
for db in $DATABASES
do
  echo "   > Creating $db database"
  DATA="{\"name\":\"${db}\"}"
  URL="${API}/db?u=root&p=root"
  curl -sk -X POST -d $DATA $URL
done

if [ ! -z "$INFLUXDB_USER" ] && [ ! -z "$INFLUXDB_PASS" ]
then
  echo "$cyan --> Setting influxdb admin user/pass$reset"

  DATA="{\"name\": \"${INFLUXDB_USER}\", \"password\": \"${INFLUXDB_PASS}\"}"
  URL="${API}/cluster_admins?u=root&p=root"
  curl -X POST -d "$DATA" "$URL"

  URL="${API}/cluster_admins/root?u=${INFLUXDB_USER}&p=${INFLUXDB_PASS}"
  curl -X DELETE "$URL"
fi

kill -9 $pid

