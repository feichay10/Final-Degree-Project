/system identity set name=P3
/interface bridge add name=lo0
/ip address add address=1.1.1.3/32 interface=lo0
/ip address add address=10.0.0.21/30 interface=ether1
/ip address add address=10.0.0.17/30 interface=ether2
/ip address add address=10.0.0.2/30 interface=ether3
/ip address add address=10.0.0.14/30 interface=ether4

/routing ospf instance add name=backbone router-id=1.1.1.3
/routing ospf area add name=backbone area-id=0.0.0.0 inst=backbone
/routing ospf interface-template add interface=lo0 network=1.1.1.3/32 area=backbone
/routing ospf interface-template add interface=ether1 network=10.0.0.21/30 area=backbone
/routing ospf interface-template add interface=ether2 network=10.0.0.17/30 area=backbone
/routing ospf interface-template add interface=ether3 network=10.0.0.2/30 area=backbone
/routing ospf interface-template add interface=ether4 network=10.0.0.14/30 area=backbone

/mpls ldp add afi=ip lsr-id=1.1.1.3 transport-addresses=1.1.1.3
/mpls ldp interface add interface=lo0
/mpls ldp interface add interface=ether1
/mpls ldp interface add interface=ether2
/mpls ldp interface add interface=ether3
/mpls ldp interface add interface=ether4
/mpls settings set dynamic-label-range=24000-25999