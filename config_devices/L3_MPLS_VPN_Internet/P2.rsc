/system identity set name=P2
/interface bridge add name=lo0
/ip address add address=1.1.1.2/32 interface=lo0
/ip address add address=10.0.0.22/30 interface=ether1
/ip address add address=10.0.0.25/30 interface=ether2

/routing ospf instance add name=backbone router-id=1.1.1.2
/routing ospf area add name=backbone area-id=0.0.0.0 inst=backbone
/routing ospf interface-template add interface=lo0 network=1.1.1.2/32 area=backbone
/routing ospf interface-template add interface=ether1 network=10.0.0.22/30 area=backbone
/routing ospf interface-template add interface=ether2 network=10.0.0.25/30 area=backbone

/mpls ldp add afi=ip lsr-id=1.1.1.2 transport-addresses=1.1.1.2
/mpls ldp interface add interface=lo0
/mpls ldp interface add interface=ether1
/mpls ldp interface add interface=ether2
/mpls settings set dynamic-label-range=22000-23999