enable
configure terminal
hostname SW_Acceso_DMZ
no ip routing
spanning-tree mode rapid-pvst

vlan 30
  name DMZ
exit

! Puertos de acceso VLAN 30
interface range GigabitEthernet0/2-3, GigabitEthernet1/0-3
  description VLAN DMZ
  switchport mode access
  switchport access vlan 30
  no shutdown
exit

! ---- EtherChannel hacia SW_Distribucion ----
interface range GigabitEthernet0/0, GigabitEthernet0/1
  description Trunks hacia SW_Distribucion
  switchport trunk encapsulation dot1q
  switchport mode trunk
  channel-group 3 mode active
  no shutdown
exit

interface Port-channel3
  description EtherChannel a SW_Distribucion
  switchport trunk encapsulation dot1q
  switchport mode trunk
  no shutdown
exit

end
write memory
