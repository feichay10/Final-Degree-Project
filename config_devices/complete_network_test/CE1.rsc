# 2025-07-04 23:14:26 by RouterOS 7.16
# software id = 
#
/interface bridge add name=lo0
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no

/port set 0 name=serial0

/ip address add address=192.170.0.1 interface=lo0 network=192.170.0.1
/ip address add address=10.0.0.1/30 interface=ether4 network=10.0.0.0

# Conexion con el router CE1_backup
/interface ethernet enable ether3
/ip address add address=192.168.1.249/30 interface=ether3

# Crear Bonding con LACP (802.3ad) (EtherChannel)
/interface bonding add name=bond1 mode=802.3ad slaves=ether1,ether2 transmit-hash-policy=layer-2-and-3

# VLANs sobre el bonding
/interface vlan add name=vlan10-datos vlan-id=10 interface=bond1 mtu=1480
/interface vlan add name=vlan20-voz   vlan-id=20 interface=bond1 mtu=1480
/interface vlan add name=vlan30-dmz   vlan-id=30 interface=bond1 mtu=1480

# Asignar direcciones IP
/ip address add address=192.168.1.1/26 interface=vlan10-datos
/ip address add address=192.168.1.65/26 interface=vlan20-voz
/ip address add address=192.168.1.129/28 interface=vlan30-dmz

# Configuración VRRP en las VLANs
/interface vrrp add name=vrrp-datos interface=vlan10-datos vrid=10 priority=150
/interface vrrp add name=vrrp-voz interface=vlan20-voz vrid=20 priority=150
/interface vrrp add name=vrrp-dmz interface=vlan30-dmz vrid=30 priority=150

# Direcciones virtuales VRRP
/ip address add address=192.168.1.3/26 interface=vrrp-datos
/ip address add address=192.168.1.67/26 interface=vrrp-voz
/ip address add address=192.168.1.131/28 interface=vrrp-dmz

# DHCP relay
/ip dhcp-relay add name=relay-datos interface=vlan10-datos local-address=192.168.1.1 dhcp-server=192.168.1.132 disabled=no
/ip dhcp-relay add name=relay-voz interface=vlan20-voz local-address=192.168.1.65 dhcp-server=192.168.1.132 disabled=no
/ip dhcp-relay add name=relay-dmz interface=vlan30-dmz local-address=192.168.1.129 dhcp-server=192.168.1.132 disabled=no

# Firewall básico
# /ip firewall filter add chain=forward action=accept protocol=udp src-port=67,68 dst-port=67,68 comment="Permitir tráfico DHCP"
# /ip firewall filter add chain=forward action=accept comment="Permitir comunicación entre VLANs"

/ip dhcp-client add interface=ether1
# Exportar las redes de cliente a la VPN MPLS
# /ip firewall address-list add address=192.168.1.0/24 list=BGP_OUT
/ip firewall address-list add address=192.168.1.0/26 list=BGP_OUT
/ip firewall address-list add address=192.168.1.64/26 list=BGP_OUT
/ip firewall address-list add address=192.168.1.128/28 list=BGP_OUT   # DMZ
/ip firewall nat add action=masquerade chain=srcnat dst-address=!192.168.0.0/16 out-interface=ether4

/ip route add gateway=10.0.0.2

/routing bgp connection
add as=65500 connect=yes listen=yes local.address=10.0.0.1 .role=ebgp name=\
    toPE2 output.network=BGP_OUT remote.address=10.0.0.2 .as=65000 router-id=\
    192.170.0.1

/system identity set name=CE1

# Asegurarte que ether1 está habilitado (por si acaso)
/interface ethernet set [find name=ether1] disabled=no

/system note set show-at-login=no