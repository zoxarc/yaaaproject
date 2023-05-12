#!/bin/sh

function setup {
  ip netns add client
  ip netns add server
  ip link add veth0 type veth peer name veth1
  ip link set veth0 netns server
  ip link set veth1 netns client
  ip netns exec server ip addr add dev veth0 192.168.99.101/24
  ip netns exec client ip addr add dev veth1 192.168.99.202/24
  ip netns exec server ip link set dev veth0 up
  ip netns exec client ip link set dev veth1 up
}

function run {
  ip netns exec server python3.10 server.py & ip netns exec client python3.10 client.py > outclient
}

output="$(ip netns list)"
if [[ -z $output ]]; then setup; fi
run
