enable
config t
hostname SW_Acceso_DMZ
no ip routing
spanning-tree mode rapid-pvst
vlan 30
name DMZ
exit
interface range GigabitEthernet0/2-3, GigabitEthernet1/0-3
description VLAN DMZ
switchport mode access
switchport access vlan 30
no shutdown
exit
interface GigabitEthernet0/0
description Trunk principal a SW_Distribucion
switchport trunk encapsulation dot1q
switchport mode trunk
no shutdown
exit
interface GigabitEthernet0/1
description Trunk secundario a SW_Distribucion (redundante)
switchport trunk encapsulation dot1q
switchport mode trunk
no shutdown
exit
end
write memory
