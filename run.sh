#!/bin/sh

function setupclient {
  name=$1
  id=$2
  ip netns add $name
  ip link add veth$id type veth peer name vethc$id
  ip link set veth$id netns server
  ip link set vethc$id netns $name
  ip netns exec server ip link set dev veth$id up
  ip netns exec server ip addr add dev veth$id 192.168.99.1/24
  ip netns exec $name ip link set dev vethc$id up
  ip netns exec $name ip addr add dev vethc$id 192.168.99.${id}00/24
}

function setupserver {
  ip netns add server
}

# set up the network namespaces
function setup {
  setupserver
  for ((i=1; i<=$clienta; i++))
  do
    setupclient "client$i" $i
  done
}

function run {
  rm -f /home/zohar/py/project/output/*
  ip netns exec server python3.10 main.py > output/server 2> output/servererr &
  for ((i=1; i<=$clienta; i++))
  do
    echo $i &
    ip netns exec client$i python3.10 client.py > output/client$i 2> output/err$i &
  done
}

clienta=0;
if [[ -z $1 ]]; then clienta=1; else clienta=$1; fi
output="$(ip netns list)"
if [[ -z $output ]]; then setup; fi
run
