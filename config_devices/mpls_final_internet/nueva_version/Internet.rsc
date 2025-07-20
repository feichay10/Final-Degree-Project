# 2025-07-06 22:10:45 by RouterOS 7.16
# software id = 
#
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
add address=50.0.0.2/30 interface=ether1 network=50.0.0.0
/ip dhcp-client
add interface=ether1
add interface=ether2
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether2
/ip route
add dst-address=10.0.0.0/30 gateway=50.0.0.1
/system note
set show-at-login=no
