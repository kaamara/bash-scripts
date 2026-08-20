#!/usr/bin/env bash
echo "-----------------------------"
echo "        NETWORK STATS        "     
echo "-----------------------------"

echo "==================="
echo "----IP ADDRESS-----"
echo "==================="
ip=$(hostname -I | awk '{print $1}')
interface=$(ip route | awk '/default/ { print $5 }')
echo "IP Address: $ip"
echo "Interface: $interface"

echo "==================="
echo "-----GATEWAY------"
echo "==================="
gateway=$(ip route | awk '/default/ {print $3}')
echo "Gateway: $gateway"

echo "==================="
echo "----DNS SERVERS----"
echo "==================="
dns=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}'| xargs)
echo "DNS Servers: $dns"

echo "==================="
echo "---INTERNET TEST---"
echo "==================="
if ping -c 3 8.8.8.8; then
    echo "Internet:  ONLINE"
else
    echo "Internet:  OFFLINE"
fi
echo "-----------------------------"
