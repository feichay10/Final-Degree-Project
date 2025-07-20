/system identity set name=CE2
/interface bridge add name=lo0
/ip address add address=1.1.1.22/32 interface=lo0
/ip address add address=172.16.0.6/30 interface=ether1
/ip address add address=192.168.2.1/24 interface=ether2

/ip firewall address-list add address=192.168.2.0/24 list=BGP_OUT
/routing bgp connection add name=toPE2 as=65500 router-id=1.1.1.22 local.address=172.16.0.6 .role=ebgp remote.address=172.16.0.5 remote.as=65000 output.network=BGP_OUT connect=yes listen=yes

