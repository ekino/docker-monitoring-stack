# ekino/grafana

## Description

Ekino's Grafana container to be used with ekino/influxdb

See main project page for details : [docker-monitoring-stack](https://github.com/ekino/docker-monitoring-stack)

## Usage

```bash
docker build -t ekino/grafana:base .
docker run -d -P ekino/grafana:base
```

## Advanced Usage

### InfluxDB settings

Set database name, remote url and user/pass with the following environment variables:
* `INFLUXDB_DBNAME`
* `INFLUXDB_USER`
* `INFLUXDB_PASS`
* `INFLUXDB_URL`

Sample invocation below:
```bash
docker run -d -p 80:8080 \
  -e INFLUXDB_DBNAME=collectdb \
  -e INFLUXDB_USER=metricsadm \
  -e INFLUXDB_PASS=somETh1ngC0Wbl6x \
  -e INFLUXDB_URL=https://influx.example.com \
  ekino/grafana:base
```
