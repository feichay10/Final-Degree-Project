enable
config t
hostname SW_Acceso_LAN
no ip routing
spanning-tree mode rapid-pvst
vlan 10
name Datos
exit
vlan 20
name Voz
exit
interface range GigabitEthernet0/2-3, GigabitEthernet1/0-3, GigabitEthernet2/0
description VLAN Datos
switchport mode access
switchport access vlan 10
no shutdown
exit
interface range GigabitEthernet2/1-3, GigabitEthernet3/0-3
description VLAN Voz
switchport mode access
switchport access vlan 20
no shutdown
exit
interface GigabitEthernet0/0
description Trunk principal a SW_Distribucion
switchport trunk encapsulation dot1q
switchport mode trunk
no shutdown
exit
interface GigabitEthernet1/0
description Trunk secundario a SW_Distribucion (redundante)
switchport trunk encapsulation dot1q
switchport mode trunk
no shutdown
exit
end
write memory