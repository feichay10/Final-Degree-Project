# 2025-07-06 16:31:45 by RouterOS 7.16
# software id = 
#
/interface bridge
add name=bridge-trunk
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
/interface vlan
add interface=bridge-trunk name=vlan10-datos vlan-id=10
add interface=bridge-trunk name=vlan20-voz vlan-id=20
add interface=bridge-trunk name=vlan30-dmz vlan-id=30
/interface vrrp
add interface=vlan10-datos name=vrrp-datos priority=150 vrid=10
add interface=vlan30-dmz name=vrrp-dmz priority=150 vrid=30
add interface=vlan20-voz name=vrrp-voz priority=150 vrid=20
/port
set 0 name=serial0
/interface bridge port
add bridge=bridge-trunk interface=ether1
add bridge=bridge-trunk interface=ether2
/ip address
add address=192.170.0.1 interface=lo0 network=192.170.0.1
add address=10.0.0.1/30 interface=ether4 network=10.0.0.0
add address=192.168.1.249/30 interface=ether3 network=192.168.1.248
add address=192.168.1.1/26 interface=vlan10-datos network=192.168.1.0
add address=192.168.1.65/26 interface=vlan20-voz network=192.168.1.64
add address=192.168.1.129/28 interface=vlan30-dmz network=192.168.1.128
add address=192.168.1.3/26 interface=vrrp-datos network=192.168.1.0
add address=192.168.1.67/26 interface=vrrp-voz network=192.168.1.64
add address=192.168.1.131/28 interface=vrrp-dmz network=192.168.1.128
/ip dhcp-client
# Interface not active
add interface=ether1
/ip dhcp-relay
add dhcp-server=192.168.1.132 disabled=no interface=vlan10-datos \
    local-address=192.168.1.1 name=relay-datos
add dhcp-server=192.168.1.132 disabled=no interface=vlan20-voz local-address=\
    192.168.1.65 name=relay-voz
add dhcp-server=192.168.1.132 disabled=no interface=vlan30-dmz local-address=\
    192.168.1.129 name=relay-dmz
/ip firewall address-list
add address=192.168.0.0/16 list=BGP_OUT
/ip firewall filter
add action=accept chain=forward comment="Permitir trfico DHCP" dst-port=67,68 \
    protocol=udp src-port=67,68
add action=accept chain=forward comment="Permitir comunicacin entre VLANs"
/ip firewall nat
add action=masquerade chain=srcnat dst-address=!192.168.0.0/16 out-interface=\
    ether4
/ip route
add gateway=10.0.0.2
/routing bgp connection
add as=65500 connect=yes listen=yes local.address=10.0.0.1 .role=ebgp name=\
    toPE2 output.network=BGP_OUT remote.address=10.0.0.2 .as=65000 router-id=\
    192.170.0.1
/system identity
set name=CE1
/system note
set show-at-login=no
