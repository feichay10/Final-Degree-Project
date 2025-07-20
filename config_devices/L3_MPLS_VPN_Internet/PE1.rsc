/system identity set name=PE1
/interface bridge add name=lo0
/ip address add address=1.1.1.11/32 interface=lo0 network=1.1.1.11
/ip address add address=10.0.0.1/30 interface=ether1 network=10.0.0.0
/ip address add address=172.16.0.1/30 interface=ether2 network=172.16.0.0
/ip address add address=10.0.0.13/30 interface=ether3 network=10.0.0.12

/routing ospf instance add name=backbone router-id=1.1.1.11
/routing ospf area add name=backbone area-id=0.0.0.0 inst=backbone
/routing ospf interface-template add interface=lo0 network=1.1.1.11/32 area=backbone
/routing ospf interface-template add interface=ether1 network=10.0.0.1/30 area=backbone

/mpls ldp add afi=ip lsr-id=1.1.1.11 transport-addresses=1.1.1.11
/mpls ldp interface add interface=lo0
/mpls ldp interface add interface=ether1
/mpls settings set dynamic-label-range=10000-11999

/routing bgp template set default address-families=ip,vpnv4 as=65000 router-id=1.1.1.11
/routing bgp connection
add connect=yes disabled=no listen=yes local.address=1.1.1.11 .role=ibgp \
    name=toPE2 remote.address=1.1.1.12 .as=65000 templates=default
/routing bgp connection
add connect=yes disabled=no listen=yes local.address=1.1.1.11 .role=ibgp \
    name=toPE3 remote.address=1.1.1.13 .as=65000 templates=default
/routing bgp connection
add connect=yes disabled=no listen=yes local.address=1.1.1.11 .role=ibgp \
    name=toPE4 remote.address=1.1.1.14 .as=65000 templates=default

/ip vrf add name=CE1 interfaces=ether2 

/routing bgp vpn
add export.redistribute=connected,static,bgp .route-targets=65000:100 \
    import.route-targets=65000:100 label-allocation-policy=per-vrf name=\
    bgp-mpls-vpn-1 route-distinguisher=65000:100 vrf=CE1

/routing bgp connection
add as=65000 connect=yes disabled=yes listen=yes local.address=172.16.0.1 \
    .role=ebgp name=toCE1 output.default-originate=always remote.address=\
    172.16.0.2 .as=65500 router-id=1.1.1.11 routing-table=CE1 vrf=CE1

/routing bgp connection add as=65000 connect=yes disabled=yes listen=yes local.address=172.16.0.1 .role=ebgp name=toCE1 output.default-originate=always remote.address=172.16.0.2 .as=65500 router-id=1.1.1.11 routing-table=CE1 vrf=CE1

/ip firewall mangle
add action=mark-routing chain=prerouting dst-address=!192.168.0.0/16 \
    in-interface=ether2 new-routing-mark=main passthrough=yes
/ip route add gateway=172.16.0.2@CE1 routing-table=CE1
/ip route add gateway=10.0.0.14
/ip route add dst-address=172.16.0.0/30 gateway=CE1@CE1 routing-table=main