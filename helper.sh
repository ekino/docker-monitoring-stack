#!/bin/bash
#set -x

command -v docker || curl http://get.docker.com/ | sh

cyan="$(tput setaf 6)"
green="$(tput setaf 2)"
bgreen="$(tput bold ; tput setaf 2)"
red="$(tput setaf 1)"
reset="$(tput sgr0)"

INFLUX_NAME=influx
GRAFANA_NAME=grafana
COLLECTD_NAME=collectd
INFLUX_DATABASE=collectdb

echo ${1%:*}

for args in $@
do
  case ${1%:*} in
    'clear'|'clean')
      echo -e "\n${cyan}==> Killing running containers${reset}"
      docker kill $INFLUX_NAME $GRAFANA_NAME $COLLECTD_NAME
      echo -e "\n${cyan}==> Removing *all* containers${reset}"
      docker rm $INFLUX_NAME $GRAFANA_NAME $COLLECTD_NAME
      echo -e "\n${cyan}==> Removing untagged/dangled images${reset}"
      [ "${1#*:}" = "all" ] && docker rmi $(docker images -qf dangling=true)
      ;;
    'build')
      for name in influxdb grafana collectd
      do
        nocache=
        [ "${1#*:}" = "nocache" ] && nocache="--no-cache"
        echo -e "\n${cyan}==> Building $name image${reset}"
        docker build $nocache -t=ekino/$name:latest $name/
      done
      ;;
    'run')
      # Start local INFLUXDB server
      echo -e "\n${cyan}==> Starting $INFLUX_NAME server${reset}"
      docker run --name $INFLUX_NAME -d -p 8083:8083 -p 8086:8086 -p 25826:25826/udp -e DATABASES=$INFLUX_DATABASE ekino/influxdb:latest
      influxip=$(docker inspect --format {{.NetworkSettings.IPAddress}} $INFLUX_NAME)
      w=20 ; echo -e "\n${cyan}==> Waiting ${w}s for influxdb container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      # Start local GRAFANA server
      echo -e "\n${cyan}==> Starting $GRAFANA_NAME server${reset}"
      docker run --name $GRAFANA_NAME --link $INFLUX_NAME:$INFLUX_NAME -d -p 80:8080 -e INFLUXDB_URL="http://$INFLUX_NAME:8086" -e DB_NAME=$INFLUX_DATABASE ekino/grafana:latest
      w=5 ; echo -e "\n${cyan}==> Waiting ${w}s for grafana container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      # Start local COLLECTD server (useful to have the full workflow, but kind of meaningless)
      echo -e "\n${cyan}==> Starting $COLLECTD_NAME server${reset}"
      docker run --name $COLLECTD_NAME --link $INFLUX_NAME:$INFLUX_NAME -d -e INFLUXDB_HOST=$INFLUX_NAME ekino/collectd:latest
      w=5 ; echo -e "\n${cyan}==> Waiting ${w}s for collectd container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      # The end
      cat <<EOF
  ${green}
  [COLLECTD]
  Optionnally check if your collectd client is setup to send metric to influxdb server IP :
  ${cyan}
    docker exec $COLLECTD_NAME sed -n '/<Plugin network>/,/<\/Plugin>/p' /etc/collectd/collectd.conf
  ${green}
  [INFLUXDB]
  Optionally check if you do receive data inside your container (10s interval between packets) :
  ${cyan}
    docker exec -ti $INFLUX_NAME tcpdump -n -i any 'port 25826'
  ${green}
  Optionally check if you have data inside '$INFLUX_DATABASE' :
  ${cyan}
    - go to http://localhost:8083
    - connect using root/root
    - click 'explore data' for 'collectdb' database
    - execute query 'list series' (long list of series should be displayed here)
  ${bgreen}
  [GRAFANA]
  Finally check the dashboard :
  ${cyan}
    - be sure '$INFLUX_NAME' can be resolved from your host (may require adding an entry in /etc/hosts)
    - open your browser and go to http://localhost
  ${reset}
EOF
      ;;
  esac
  shift
done 3>&1 1>&2 2>&3 | awk '{print "'$red'" $0 "'$reset'"}'
