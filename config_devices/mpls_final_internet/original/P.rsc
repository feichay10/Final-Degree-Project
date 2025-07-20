# 2025-07-05 15:58:26 by RouterOS 7.16
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
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=backbone router-id=192.170.0.3
/routing ospf area
add disabled=no instance=backbone name=backbone
/ip address
add address=192.170.0.3 interface=lo0 network=192.170.0.3
add address=30.0.0.1/30 interface=ether3 network=30.0.0.0
add address=40.0.0.1/30 interface=ether4 network=40.0.0.0
/ip dhcp-client
# Interface not active
add interface=ether1
/mpls ldp
add afi=ip lsr-id=192.170.0.3 transport-addresses=192.170.0.3
/mpls ldp interface
add interface=lo0
add interface=ether3
add interface=ether4
/mpls settings
set dynamic-label-range=30000-39999
/routing ospf interface-template
add area=backbone disabled=no interfaces=lo0 networks=192.170.0.3/32
add area=backbone disabled=no interfaces=ether3 networks=30.0.0.0/30
add area=backbone disabled=no interfaces=ether4 networks=40.0.0.0/30
add area=backbone disabled=no interfaces=ether1 networks=50.0.0.0/30
/system identity
set name=P
/system note
set show-at-login=no
