# 2025-07-06 22:12:13 by RouterOS 7.16
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
add interfaces=ether2 name=CE2
/port
set 0 name=serial0
/routing bgp template
set default address-families=ip,vpnv4 as=65000
/routing ospf instance
add disabled=no name=backbone router-id=192.170.0.4
/routing ospf area
add disabled=no instance=backbone name=backbone
/ip address
add address=192.170.0.4 interface=lo0 network=192.170.0.4
add address=40.0.0.2/30 interface=ether4 network=40.0.0.0
add address=20.0.0.2/30 interface=ether2 network=20.0.0.0
/ip dhcp-client
# Interface not active
add interface=ether1
/mpls ldp
add afi=ip lsr-id=192.170.0.4 transport-addresses=192.170.0.4
/mpls ldp interface
add interface=lo0
add interface=ether4
/mpls settings
set dynamic-label-range=20000-29999
/routing bgp connection
add connect=yes listen=yes local.address=192.170.0.4 .role=ibgp name=toPE1 \
    remote.address=192.170.0.2 .as=65000 templates=default
add as=65000 connect=yes listen=yes local.address=20.0.0.2 .role=ebgp name=\
    toCE2 output.default-originate=always remote.address=20.0.0.1 .as=65500 \
    router-id=192.170.0.4 routing-table=CE2 vrf=CE2
/routing bgp vpn
add export.redistribute=connected,static,bgp .route-targets=65000:100 \
    import.route-targets=65000:100 label-allocation-policy=per-vrf name=\
    bgp-mpls-vpn-1 route-distinguisher=65000:100 vrf=CE2
/routing ospf interface-template
add area=backbone disabled=no interfaces=lo0 networks=192.170.0.4/32
add area=backbone disabled=no interfaces=ether4 networks=40.0.0.0/30
/system identity
set name=PE2
/system note
set show-at-login=no
