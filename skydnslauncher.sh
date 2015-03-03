#!/usr/bin/env bash

# If ETCD_HOSTS isn't populated, assume that the docker host is the
# gateway on the default route. If we're in CoreOS, ETCD will be
# running there on port 4001

if [ -z "$ETCD_HOSTS" ]; then
    docker_host=$(ip route | grep default | cut -d' ' -f3)
    >&2 echo "set ETCD_MACHINES to ${docker_host}"
    my_host=$(ifconfig eth0 | grep 'inet ' | awk '{print $2'} | sed 's/addr://')
    >&2 echo "set SKYDNS_ADDR to ${my_host}"
    >&2 ifconfig
    export ETCD_MACHINES="http://${docker_host}:4001"
    export SKYDNS_ADDR="${my_host}:53"
fi

skydns $@
