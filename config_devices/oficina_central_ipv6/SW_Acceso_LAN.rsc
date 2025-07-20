enable
configure terminal
hostname SW_Acceso_LAN
no ip routing
spanning-tree mode rapid-pvst

vlan 10
  name Datos
exit
vlan 20
  name Voz
exit

! Puertos de acceso VLAN 10
interface range GigabitEthernet0/2-3, GigabitEthernet1/1-3, GigabitEthernet2/0
  description VLAN Datos
  switchport mode access
  switchport access vlan 10
  no shutdown
exit

! Puertos de acceso VLAN 20
interface range GigabitEthernet2/1-3, GigabitEthernet3/0-3
  description VLAN Voz
  switchport mode access
  switchport access vlan 20
  no shutdown
exit

! ---- EtherChannel hacia SW_Distribucion ----
interface range GigabitEthernet0/0, GigabitEthernet0/1
  description Trunks hacia SW_Distribucion
  switchport trunk encapsulation dot1q
  switchport mode trunk
  channel-group 4 mode active
  no shutdown
exit

interface Port-channel4
  description EtherChannel a SW_Distribucion
  switchport trunk encapsulation dot1q
  switchport mode trunk
  no shutdown
exit

end
write memory
