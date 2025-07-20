enable
config t
hostname SW_Distribucion
no ip routing
spanning-tree mode rapid-pvst
vlan 10
  name Datos
exit9
vlan 20
  name Voz
exit
vlan 30
  name DMZ
exit
interface GigabitEthernet0/0
  description Trunk to Router MikroTik CE1
  switchport trunk encapsulation dot1q
  switchport mode trunk
  spanning-tree portfast trunk
  no shutdown
exit
interface GigabitEthernet0/1
  description Segundo Trunk a Router MikroTik CE1 (redundante)
  switchport trunk encapsulation dot1q
  switchport mode trunk
  spanning-tree portfast trunk
  no shutdown
exit
interface GigabitEthernet0/2
  description Trunk to SW_Acceso_LAN
  switchport trunk encapsulation dot1q
  switchport mode trunk
  no shutdown
exit
interface GigabitEthernet1/0
  description Segundo Trunk a SW_Acceso_LAN (redundante)
  switchport trunk encapsulation dot1q
  switchport mode trunk
  no shutdown
exit
interface GigabitEthernet0/3
  description Trunk to SW_Acceso_DMZ
  switchport trunk encapsulation dot1q
  switchport mode trunk
  no shutdown
exit
interface GigabitEthernet1/1
  description Segundo Trunk a SW_Acceso_DMZ (redundante)
  switchport trunk encapsulation dot1q
  switchport mode trunk
  no shutdown
exit
end
write memory