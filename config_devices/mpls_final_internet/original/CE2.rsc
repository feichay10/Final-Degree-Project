# 2025-07-05 15:59:41 by RouterOS 7.16
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
/ip address
add address=192.170.0.5 interface=lo0 network=192.170.0.5
add address=20.0.0.1/30 interface=ether2 network=20.0.0.0
add address=192.168.2.1/24 interface=ether1 network=192.168.2.0
/ip dhcp-client
add interface=ether1
/ip firewall address-list
add address=192.168.2.0/24 list=BGP_OUT
/ip firewall nat
add action=masquerade chain=srcnat dst-address=!192.168.0.0/16 out-interface=\
    ether2
/ip route
add gateway=20.0.0.2
/routing bgp connection
add as=65500 connect=yes listen=yes local.address=20.0.0.1 .role=ebgp name=\
    toPE2 output.network=BGP_OUT remote.address=20.0.0.2 .as=65000 router-id=\
    192.170.0.5
/system identity
set name=CE2
/system note
set show-at-login=no
