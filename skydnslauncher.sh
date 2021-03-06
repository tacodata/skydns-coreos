#!/usr/bin/env bash

# If ETCD_HOSTS isn't populated, assume that the docker host is the
# gateway on the default route. If we're in CoreOS, ETCD will be
# running there on port 4001

if [ -z "$ETCD_HOSTS" ]; then
    docker_host=$(ip route | grep default | cut -d' ' -f3)
    >&2 echo "set ETCD_MACHINES to ${docker_host}"
    my_host=$(grep $(hostname) /etc/hosts | awk '{print $1}')
    >&2 echo "set SKYDNS_ADDR to ${my_host}"
    export ETCD_MACHINES="http://${docker_host}:4001"
    export SKYDNS_ADDR="${my_host}:53"
fi

skydns $@
