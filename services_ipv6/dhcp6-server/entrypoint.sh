#!/bin/bash

# Inicia el servidor DHCPv6
exec dhcpd -6 -f -cf /etc/dhcp/dhcpd6.conf eth0