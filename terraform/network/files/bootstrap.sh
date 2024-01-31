#!/bin/bash

echo "==> Installing iptables"
yum install iptables-services -y
systemctl enable iptables
systemctl start iptables

echo ""
echo "==> Enabling ipv4 forwarding"
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/custom-ip-forwarding.conf
sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

echo ""
echo "==> Adding network interface to iptables"
interface=$(netstat -i | grep -v Iface | grep BMRU | cut -d ' ' -f1)
/sbin/iptables -t nat -A POSTROUTING -o "$interface" -j MASQUERADE
/sbin/iptables -F FORWARD
service iptables save

echo "==> Bootstrap finished"