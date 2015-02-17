#!/bin/bash
#set -x

echo "$green ==> Starting ekino/grafana:base$reset"

CNF=/opt/grafana/config.js

echo "$cyan --> Setting influxdb database name to ${INFLUXDB_DBNAME:="collectdb"}$reset"
sed -i 's/DB_NAME/'${INFLUXDB_DBNAME}'/' $CNF

echo "$cyan --> Setting influxdb user/pass$reset"
sed -i 's/INFLUXDB_USER/'${INFLUXDB_USER:-"root"}'/' $CNF
sed -i 's/INFLUXDB_PASS/'${INFLUXDB_PASS:-"root"}'/' $CNF

echo "$cyan --> Setting influxdb url to ${INFLUXDB_URL:="influxdb.local"}$reset"
sed -i 's,INFLUXDB_URL,'${INFLUXDB_URL}',' $CNF

# Start server
supervisord -n
