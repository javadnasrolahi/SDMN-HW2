#!/bin/bash 

# Create namespaces
ip netns add node1 # 172.0.0.2/24
ip netns add node2 # 172.0.0.3/24
ip netns add node3 # 10.10.0.2/24
ip netns add node4 # 10.10.0.3/24
ip netns add router # 172.0.0.2/24 , 10.10.0.1/24

# Setup node1 
ip link add veth1 type veth peer name veth-br11
ip link set veth1 up
ip link set veth-br11 netns node1

ip netns exec node1 ip link set lo up 
ip netns exec node1 ip link set veth-br11 up
ip netns exec node1 ip addr add 172.0.0.2/24 dev veth-br11
ip netns exec node1 ip route add default via 172.0.0.1

# Setup node2
ip link add veth2 type veth peer name veth-br12
ip link set veth2 up
ip link set veth-br12 netns node2

ip netns exec node2 ip link set lo up 
ip netns exec node2 ip link set veth-br12 up
ip netns exec node2 ip addr add 172.0.0.3/24 dev veth-br12
ip netns exec node2 ip route add default via 172.0.0.1


# Setup node3 
ip link add veth3 type veth peer name veth-br23
ip link set veth3 up
ip link set veth-br23 netns node3

ip netns exec node3 ip link set lo up 
ip netns exec node3 ip link set veth-br23 up
ip netns exec node3 ip addr add 10.10.0.2/24 dev veth-br23
ip netns exec node3 ip route add default via 10.10.0.1


# Setup node4
ip link add veth4 type veth peer name veth-br24
ip link set veth4 up
ip link set veth-br24 netns node4

ip netns exec node4 ip link set lo up 
ip netns exec node4 ip link set veth-br24 up
ip netns exec node4 ip addr add 10.10.0.3/24 dev veth-br24
ip netns exec node4 ip route add default via 10.10.0.1


# Setup router
ip link add veth-r1 type veth peer name veth-br1
ip link add veth-r2 type veth peer name veth-br2 

ip link set veth-r1 up 
ip link set veth-r2 up 

ip link set veth-br1 netns router
ip link set veth-br2 netns router

ip netns exec router ip addr add 172.0.0.1/24 dev veth-br1
ip netns exec router ip addr add 10.10.0.1/24 dev veth-br2

ip netns exec router ip link set veth-br1 up
ip netns exec router ip link set veth-br2 up


# Setup bridge
ip link add br1 type bridge
ip link set br1 up
ip link set veth1 master br1
ip link set veth2 master br1
ip link set veth-r1 master br1
ip addr add 172.0.0.1/24 dev br1 


ip link add br2 type bridge
ip link set br2 up
ip link set veth3 master br2
ip link set veth4 master br2
ip link set veth-r2 master br2
ip addr add 10.10.0.1/24 dev br2

