/system identity set name=Internet

/interface bridge add name=lo0
/ip address add address=1.1.1.14/32 interface=lo0 network=1.1.1.14
/ip address add address=10.0.0.14/30 interface=ether1 network=10.0.0.0

/ip dhcp-client add interface=ether2

/ip firewall nat add action=masquerade chain=srcnat out-interface=ether2
/ip route add dst-address=172.16.0.0/30 gateway=10.0.0.13
