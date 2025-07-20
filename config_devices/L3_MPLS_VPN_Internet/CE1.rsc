/system identity set name=CE1
/interface bridge add name=lo0
/ip address add address=1.1.1.21/32 interface=lo0 network=1.1.1.21
/ip address add address=192.168.1.1/24 interface=ether1 network=192.168.1.0
/ip address add address=172.16.0.2/30 interface=ether2 network= 172.16.0.0

/ip firewall address-list add address=192.168.1.0/24 list=BGP_OUT
/ip firewall nat add action=masquerade chain=srcnat dst-address=!192.168.0.0/16 out-interface=ether2

/ip route add gateway=172.16.0.1

/routing bgp connection
add as=65500 connect=yes listen=yes local.address=172.16.0.2 .role=ebgp name=\
    toPE1 output.network=BGP_OUT remote.address=172.16.0.1 .as=65000 router-id=\
    1.1.1.21