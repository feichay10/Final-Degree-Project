# Identidad
/system identity set name=CE1_backup

# Habilitar interfaces físicas
/interface ethernet enable [find]

# Conexión con el router CE1 principal (enlace de backup)
/interface ethernet enable ether3
/ip address add address=192.168.1.253/30 interface=ether3

# Bridge con RSTP
/interface bridge add name=bridge-trunk protocol-mode=rstp
/interface bridge port add bridge=bridge-trunk interface=ether1
/interface bridge port add bridge=bridge-trunk interface=ether2

# Crear VLANs sobre el bridge
/interface vlan add interface=bridge-trunk vlan-id=10 name=vlan10-datos
/interface vlan add interface=bridge-trunk vlan-id=20 name=vlan20-voz
/interface vlan add interface=bridge-trunk vlan-id=30 name=vlan30-dmz

# Asignar direcciones IP a las VLANs
/ip address add address=192.168.1.2/26 interface=vlan10-datos
/ip address add address=192.168.1.66/26 interface=vlan20-voz
/ip address add address=192.168.1.130/28 interface=vlan30-dmz

# Configuración de VRRP (como backup, menor prioridad)
/interface vrrp add name=vrrp-datos interface=vlan10-datos vrid=10 priority=100
/interface vrrp add name=vrrp-voz interface=vlan20-voz vrid=20 priority=100
/interface vrrp add name=vrrp-dmz interface=vlan30-dmz vrid=30 priority=100

# Direcciones virtuales VRRP (las mismas que CE1 principal)
/ip address add address=192.168.1.3/26 interface=vrrp-datos
/ip address add address=192.168.1.67/26 interface=vrrp-voz
/ip address add address=192.168.1.131/28 interface=vrrp-dmz

# DHCP relay configurado con la IP local de cada VLAN
/ip dhcp-relay add name=relay-datos interface=vlan10-datos local-address=192.168.1.2 dhcp-server=192.168.1.132 disabled=no
/ip dhcp-relay add name=relay-voz interface=vlan20-voz local-address=192.168.1.66 dhcp-server=192.168.1.132 disabled=no
/ip dhcp-relay add name=relay-dmz interface=vlan30-dmz local-address=192.168.1.130 dhcp-server=192.168.1.132 disabled=no

# Firewall básico
/ip firewall filter add chain=forward action=accept protocol=udp src-port=67,68 dst-port=67,68 comment="Permitir tráfico DHCP"
/ip firewall filter add chain=forward action=accept comment="Permitir comunicación entre VLANs"

# Habilitar IP forwarding
/ip settings set allow-fast-path=yes

# Dirección IP para el enlace eBGP con PE1 (backup)
/ip address add address=10.0.0.5/30 interface=ether2

# Loopback opcional para router-id
/interface bridge add name=lo0
/ip address add address=192.170.0.6/32 interface=lo0

# Exportar las redes de cliente a la VPN MPLS
/ip firewall address-list add address=192.168.1.0/26 list=BGP_OUT
/ip firewall address-list add address=192.168.1.64/26 list=BGP_OUT
/ip firewall address-list add address=192.168.1.128/28 list=BGP_OUT

# Configuración eBGP con PE1 (opcional para redundancia total)
/routing bgp connection add name=toPE1 as=65500 router-id=192.170.0.6 \
    local.address=10.0.0.5 .role=ebgp remote.address=10.0.0.2 remote.as=65000 \
    output.network=BGP_OUT connect=yes listen=yes

# Asegurarte que ether1 está habilitada
/interface ethernet set [find name=ether1] disabled=no

# Guardar configuración final
/system backup save name=CE1_backup-VRRP-RSTP-MPLSVPN
