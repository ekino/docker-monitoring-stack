# ekino/influxdb

## Description

Ekino's influxdb container

## Usage

```bash
docker build -t=ekino/influxdb:latest .
docker run -d -P ekino/influxdb:latest
```

## Advanced

Use the `DATABASES` env variable to precreate databases.

```bash
docker run -d -p 8083:8083 -p 8086:8086 -p 25826:25826 -e DATABASES=systemdb,appdb,otherdb ekino/influxdb:latest
```

## Note

No clustering, No consensus, No https  .........yet
