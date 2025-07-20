/system identity set name=PE2
/interface bridge add name=lo0
/ip address add address=1.1.1.12/32 interface=lo0
/ip address add address=172.16.0.5/30 interface=ether1
/ip address add address=10.0.0.5/30 interface=ether2

/routing ospf instance add name=backbone router-id=1.1.1.12
/routing ospf area add name=backbone area-id=0.0.0.0 inst=backbone
/routing ospf interface-template add interface=lo0 network=1.1.1.12/32 area=backbone
/routing ospf interface-template add interface=ether2 network=10.0.0.5/30 area=backbone

/mpls ldp add afi=ip lsr-id=1.1.1.12 transport-addresses=1.1.1.12
/mpls ldp interface add interface=ether2
/mpls settings set dynamic-label-range=12000-13999

/routing bgp template set default address-families=ip,vpnv4 as=65000 router-id=1.1.1.12
/routing bgp connection add name=toPE1 template=default local.address=1.1.1.12 local.role=ibgp remote.address=1.1.1.11 remote.as=65000 connect=yes listen=yes
/routing bgp connection add name=toPE3 template=default local.address=1.1.1.12 local.role=ibgp remote.address=1.1.1.13 remote.as=65000 connect=yes listen=yes
/routing bgp connection add name=toPE4 template=default local.address=1.1.1.12 local.role=ibgp remote.address=1.1.1.14 remote.as=65000 connect=yes listen=yes

/ip vrf add name=CE2 interfaces=ether1 

/routing bgp vpn add route-distinguisher=65000:100 import.route-targets=65000:100 vrf=CE2 label-allocation-policy=per-vrf export.route-targets=65000:100 .redistribute=connected,static,bgp

/routing bgp connection add name=toCE2 router-id=1.1.1.12 as=65000 local.address=172.16.0.5 .role=ebgp remote.address=172.16.0.6 .as=65500 routing-table=CE2 vrf=CE2 connect=yes listen=yes output.default-originate=always
