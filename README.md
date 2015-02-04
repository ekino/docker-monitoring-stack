# Ekino Monitoring Stack

## Description

This repo contains the following docker images sources :
* [`ekino/influxdb`](https://registry.hub.docker.com/u/ekino/influxdb/)
* [`ekino/grafana`](https://registry.hub.docker.com/u/ekino/grafana/)
* [`ekino/collectd`](https://registry.hub.docker.com/u/ekino/collectd/)

*Note:*
The collectd image is here to have the full stack locally available.
IRL it may seems it is meaningless because you'll want to gather data at host
level, not container one. But you can still use it to process actionnable
plugins like `curl_json`, `tail_csv`, `ping`...

*This is a work in progress. PR are welcomes folks :)*

## TL;DR

Execute this command :

```bash
curl -sSL https://raw.githubusercontent.com/ekino/docker-monitoring-stack/master/helper.sh | bash -s run
```

And head to your new [local Grafana instance](http://localhost/) to get this result :

![Screenshot](oneliner-result.png)

## Real-life usage

*TODO*


