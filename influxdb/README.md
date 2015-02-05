# ekino/influxdb

## Description

Ekino's influxdb container

## Usage

```bash
docker build -t=ekino/influxdb:latest .
docker run -d -P ekino/influxdb:latest
```

The collectd plugin is predefined to store input data to `collectdb`.
This database can be either changed in `config.toml` or created at startup
using the following syntax :

```bash
docker run -d -P -e DATABASES=collectdb ekino/influxdb:latest
```

## Advanced

The `DATABASES` env variable can take a comma separated list database names in
order to create them at startup.

```bash
docker run -d -p 8083:8083 -p 8086:8086 -p 25826:25826/udp -e DATABASES=systemdb,appdb,collectdb ekino/influxdb:latest
```

To decouple data and app lifecycle use a volume container
```bash
docker create -v /opt/influxdb/shared/ --name influx.data ekino/influxdb:latest
docker run -d -p 8083:8083 -p 8086:8086 -p 25826:25826/udp -e DATABASES=collectdb --volumes-from influx.data ekino/influxdb:latest
```

## Note

No clustering, No consensus, No https  .........yet
