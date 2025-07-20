# 2025-07-06 22:10:21 by RouterOS 7.16
# software id = 
#
/interface bridge
add name=lo0
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/ip vrf
add interfaces=ether2 name=CE1
/port
set 0 name=serial0
/routing bgp template
set default address-families=ip,vpnv4 as=65000
/routing ospf instance
add disabled=no name=backbone router-id=192.170.0.2
/routing ospf area
add disabled=no instance=backbone name=backbone
/ip address
add address=192.170.0.2 interface=lo0 network=192.170.0.2
add address=10.0.0.2/30 interface=ether2 network=10.0.0.0
add address=30.0.0.2/30 interface=ether3 network=30.0.0.0
add address=50.0.0.1/30 interface=ether1 network=50.0.0.0

/ip dhcp-client
add interface=ether1
/ip firewall mangle
add action=mark-routing chain=prerouting dst-address=!192.168.0.0/16 \
    in-interface=ether2 new-routing-mark=main passthrough=yes
/ip route
add gateway=10.0.0.1@CE1 routing-table=CE1
add gateway=50.0.0.2
add dst-address=10.0.0.0/30 gateway=CE1@CE1 routing-table=main

/mpls ldp
add afi=ip lsr-id=192.170.0.2 transport-addresses=192.170.0.2
/mpls ldp interface
add interface=lo0
add interface=ether3
/mpls settings
set dynamic-label-range=10000-19999

/routing bgp connection
add connect=yes disabled=no listen=yes local.address=192.170.0.2 .role=ibgp \
    name=toPE2 remote.address=192.170.0.4 .as=65000 templates=default
add as=65000 connect=yes disabled=yes listen=yes local.address=10.0.0.2 \
    .role=ebgp name=toCE1 output.default-originate=always remote.address=\
    10.0.0.1 .as=65500 router-id=192.170.0.2 routing-table=CE1 vrf=CE1
/routing bgp vpn
add export.redistribute=connected,static,bgp .route-targets=65000:100 \
    import.route-targets=65000:100 label-allocation-policy=per-vrf name=\
    bgp-mpls-vpn-1 route-distinguisher=65000:100 vrf=CE1

/routing ospf interface-template
add area=backbone disabled=no interfaces=lo0 networks=192.170.0.2/32
add area=backbone disabled=no interfaces=ether3 networks=30.0.0.0/30
/system identity
set name=PE1
/system note
set show-at-login=no
