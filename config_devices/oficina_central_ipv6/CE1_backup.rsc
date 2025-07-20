# ------------------------------------------------------------
# Identidad
/system identity set name=CE1-Backup

# ------------------------------------------------------------
# Habilitar todas las interfaces físicas
/interface ethernet enable [find]

# ------------------------------------------------------------
# Crear Bonding con LACP (802.3ad) (EtherChannel)
/interface bonding add name=bond1 mode=802.3ad slaves=ether1,ether2 transmit-hash-policy=layer-2-and-3

# ------------------------------------------------------------
# VLANs sobre el bonding
/interface vlan add name=vlan10-datos vlan-id=10 interface=bond1 mtu=1480
/interface vlan add name=vlan20-voz   vlan-id=20 interface=bond1 mtu=1480
/interface vlan add name=vlan30-dmz   vlan-id=30 interface=bond1 mtu=1480

# ------------------------------------------------------------
# Asignar direcciones IPv6 a cada VLAN
/ipv6 address add address=2001:db8:1234:0100::1/64 interface=vlan10-datos
/ipv6 address add address=2001:db8:1234:0101::1/64 interface=vlan20-voz
/ipv6 address add address=2001:db8:1234:0102::1/64 interface=vlan30-dmz

# ------------------------------------------------------------
# Configuración VRRP en las VLANs
/interface vrrp add name=vrrp-datos interface=vlan10-datos vrid=10 priority=100 version=3 v3-protocol=ipv6 mtu=1480
/interface vrrp add name=vrrp-voz   interface=vlan20-voz   vrid=20 priority=100 version=3 v3-protocol=ipv6 mtu=1480 
/interface vrrp add name=vrrp-dmz   interface=vlan30-dmz   vrid=30 priority=100 version=3 v3-protocol=ipv6 mtu=1480

# Direcciones virtuales VRRP
/ipv6 address add address=2001:db8:1234:0100::2/64 interface=vrrp-datos
/ipv6 address add address=2001:db8:1234:0101::2/64 interface=vrrp-voz
/ipv6 address add address=2001:db8:1234:0102::2/64 interface=vrrp-dmz

# ------------------------------------------------------------
# Conexion directa con CE (enlace de sincronización)
/interface ethernet enable ether3
/ipv6 address add address=2001:db8:1234:0103::2/64 interface=ether3

# ------------------------------------------------------------
# DHCPv6 relay en VLANs
/ipv6 dhcp-relay add name=relay-datos interface=vlan10-datos dhcp-server=2001:db8:1234:0102::132 link-address=2001:db8:1234:0100::1 disabled=no
/ipv6 dhcp-relay add name=relay-voz   interface=vlan20-voz   dhcp-server=2001:db8:1234:0102::132 link-address=2001:db8:1234:0101::1 disabled=no

# ------------------------------------------------------------
# Neighbor Discovery (RA, DNS)
/ipv6 nd add interface=vlan10-datos advertise-dns=yes managed-address-configuration=yes other-configuration=yes ra-lifetime=1800 ra-preference=low dns=2001:db8:1234:0102::133,2001:db8:1234:0102::134
/ipv6 nd add interface=vlan20-voz   advertise-dns=yes managed-address-configuration=yes other-configuration=yes ra-lifetime=1800 ra-preference=low dns=2001:db8:1234:0102::133,2001:db8:1234:0102::134
/ipv6 nd add interface=vlan30-dmz   advertise-dns=yes dns=2001:db8:1234:0102::133,2001:db8:1234:0102::134

# ------------------------------------------------------------
# Firewall básico IPv6
/ipv6 firewall filter add chain=forward action=accept protocol=udp dst-port=53 comment="Permitir tráfico DNS"
/ipv6 firewall filter add chain=forward action=accept protocol=tcp dst-port=53 comment="Permitir tráfico DNS"
/ipv6 firewall filter add chain=forward action=accept protocol=udp dst-port=547 comment="Permitir tráfico DHCPv6"
/ipv6 firewall filter add chain=forward action=accept comment="Permitir comunicación entre VLANs"
/ipv6 firewall filter add chain=forward action=accept protocol=icmpv6 comment="Permitir tráfico ICMPv6 entre VLANs y servidor DNS"
/ipv6 firewall filter add chain=forward action=accept src-address=2001:db8:1234:0100::/64 dst-address=2001:db8:1234:0102::/64 comment="Datos → DMZ"
/ipv6 firewall filter add chain=forward action=accept src-address=2001:db8:1234:0101::/64 dst-address=2001:db8:1234:0102::/64 comment="Voz → DMZ"
/ipv6 firewall filter add chain=forward action=accept src-address=2001:db8:1234:0102::/64 dst-address=2001:db8:1234:0100::/64 comment="DMZ → Datos"
/ipv6 firewall filter add chain=forward action=accept src-address=2001:db8:1234:0102::/64 dst-address=2001:db8:1234:0101::/64 comment="DMZ → Voz"

# ------------------------------------------------------------
# Activar fast-path (si aplica)
/ip settings set allow-fast-path=yes

# ------------------------------------------------------------
# Guardar configuración
/system backup save name=CE1-Backup
