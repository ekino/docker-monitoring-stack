#!/bin/bash

#set -x

CNF=/opt/grafana/config.js
sed -i 's/DB_NAME/'${DB_NAME:-"collectdb"}'/' $CNF
sed -i 's/INFLUXDB_USER/'${INFLUXDB_USER:-"root"}'/' $CNF
sed -i 's/INFLUXDB_PASS/'${INFLUXDB_PASS:-"root"}'/' $CNF
sed -i 's,INFLUXDB_URL,'${INFLUXDB_URL:-"root"}',' $CNF

# Start server
supervisord -n
