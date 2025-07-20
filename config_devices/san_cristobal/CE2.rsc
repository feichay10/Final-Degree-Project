# Identidad
/system identity set name=CE2

# Habilitar interfaces físicas
/interface ethernet enable [find]

# VLANs sobre ether1
/interface vlan add interface=ether1 vlan-id=10 name=vlan10-datos
/interface vlan add interface=ether1 vlan-id=20 name=vlan20-voz

# Asignar direcciones IP
/ip address add address=192.168.2.1/27 interface=vlan10-datos
/ip address add address=192.168.2.33/27 interface=vlan20-voz

# Pool de direcciones DHCP
/ip pool add name=pool_datos ranges=192.168.2.2-192.168.2.30
/ip pool add name=pool_voz ranges=192.168.2.34-192.168.2.62

# Servidor DHCP para VLAN 10 (Datos)
/ip dhcp-server add name=dhcp_datos interface=vlan10-datos address-pool=pool_datos disabled=no
/ip dhcp-server network add address=192.168.2.0/27 gateway=192.168.2.1

# Servidor DHCP para VLAN 20 (Voz)
/ip dhcp-server add name=dhcp_voz interface=vlan20-voz address-pool=pool_voz disabled=no
/ip dhcp-server network add address=192.168.2.32/27 gateway=192.168.2.33

# Firewall: bloquear tráfico entre VLANs
/ip firewall filter add chain=forward action=drop src-address=192.168.2.0/27 dst-address=192.168.2.32/27 comment="Bloquear Datos -> Voz"
/ip firewall filter add chain=forward action=drop src-address=192.168.2.32/27 dst-address=192.168.2.0/27 comment="Bloquear Voz -> Datos"

# Habilitar IP forwarding
/ip settings set allow-fast-path=yes

# Direcciones IP para BGP e interconexión MPLS
/ip address add address=20.0.0.1/30 interface=ether2

# Loopback (opcional para router-id)
/interface bridge add name=lo0
/ip address add address=192.170.0.5/32 interface=lo0

# Exportar las redes a la VPN MPLS
/ip firewall address-list add address=192.168.2.0/27 list=BGP_OUT
/ip firewall address-list add address=192.168.2.32/27 list=BGP_OUT

# Configuración eBGP con PE2
/routing bgp connection add name=toPE2 as=65500 router-id=192.170.0.5 \
    local.address=20.0.0.1 .role=ebgp remote.address=20.0.0.2 remote.as=65000 \
    output.network=BGP_OUT connect=yes listen=yes

# Asegurarte que ether1 está habilitada
/interface ethernet set [find name=ether1] disabled=no

# Guardar configuración final
/system backup save name=CE2-VLANs-MPLSVPN-completa
