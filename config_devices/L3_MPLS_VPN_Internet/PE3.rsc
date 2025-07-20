/system identity set name=PE3
/interface bridge add name=lo0
/ip address add address=1.1.1.13/32 interface=lo0
/ip address add address=10.0.0.9/30 interface=ether1
/ip address add address=172.16.0.9/30 interface=ether2

/routing ospf instance add name=backbone router-id=1.1.1.13
/routing ospf area add name=backbone area-id=0.0.0.0 inst=backbone
/routing ospf interface-template add interface=lo0 network=1.1.1.13/32 area=backbone
/routing ospf interface-template add interface=ether1 network=10.0.0.9/30 area=backbone

/mpls ldp add afi=ip lsr-id=1.1.1.13 transport-addresses=1.1.1.13
/mpls ldp interface add interface=ether1
/mpls settings set dynamic-label-range=14000-15999

/routing bgp template set default address-families=ip,vpnv4 as=65000 router-id=1.1.1.13
/routing bgp connection add name=toPE1 template=default local.address=1.1.1.13 local.role=ibgp remote.address=1.1.1.11 remote.as=65000 connect=yes listen=yes
/routing bgp connection add name=toPE2 template=default local.address=1.1.1.13 local.role=ibgp remote.address=1.1.1.12 remote.as=65000 connect=yes listen=yes
/routing bgp connection add name=toPE4 template=default local.address=1.1.1.13 local.role=ibgp remote.address=1.1.1.14 remote.as=65000 connect=yes listen=yes

/ip vrf add name=CE3 interfaces=ether2 

/routing bgp vpn add route-distinguisher=65000:100 import.route-targets=65000:100 vrf=CE3 label-allocation-policy=per-vrf export.route-targets=65000:100 .redistribute=connected,static,bgp

/routing bgp connection add name=toCE3 router-id=1.1.1.13 as=65000 local.address=172.16.0.9 .role=ebgp remote.address=172.16.0.10 .as=65500 routing-table=CE3 vrf=CE3 connect=yes listen=yes output.default-originate=always
