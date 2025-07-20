/system identity set name=CE3
/interface bridge add name=lo0
/ip address add address=1.1.1.23/32 interface=lo0
/ip address add address=172.16.0.10/30 interface=ether1
/ip address add address=192.168.3.1/24 interface=ether2

/ip firewall address-list add address=192.168.3.0/24 list=BGP_OUT
/routing bgp connection add name=toPE3 as=65500 router-id=1.1.1.23 local.address=172.16.0.10 .role=ebgp remote.address=172.16.0.9 remote.as=65000 output.network=BGP_OUT connect=yes listen=yes