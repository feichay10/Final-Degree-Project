enable
configure terminal
hostname SW_Distribucion
no ip routing
spanning-tree mode rapid-pvst

! VLANs
vlan 10
  name Datos
exit
vlan 20
  name Voz
exit
vlan 30
  name DMZ
exit

! --------------------------
! EtherChannel 1: CE1 (Router Principal)
! Puertos: Gi0/0 y Gi0/1
interface range GigabitEthernet0/0 - 1
  description EtherChannel to Router CE1
  switchport trunk encapsulation dot1q
  switchport mode trunk
  channel-group 1 mode active
  spanning-tree portfast trunk
  no shutdown
exit

interface Port-channel1
  description Port-Channel to Router CE1
  switchport trunk encapsulation dot1q
  switchport mode trunk
  spanning-tree portfast trunk
  no shutdown
exit

! --------------------------
! EtherChannel 2: CE1_Backup (Router Secundario)
! Puertos: Gi0/2 y Gi0/3
interface range GigabitEthernet0/2 - 3
  description EtherChannel to Router CE1_Backup
  switchport trunk encapsulation dot1q
  switchport mode trunk
  channel-group 2 mode active
  spanning-tree portfast trunk
  no shutdown
exit

interface Port-channel2
  description Port-Channel to Router CE1_Backup
  switchport trunk encapsulation dot1q
  switchport mode trunk
  spanning-tree portfast trunk
  no shutdown
exit

! --------------------------
! EtherChannel 3: SW_Acceso_DMZ
! Puertos: Gi1/0 y Gi1/1
interface range GigabitEthernet1/0 - 1
  description EtherChannel to SW_Acceso_DMZ
  switchport trunk encapsulation dot1q
  switchport mode trunk
  channel-group 3 mode active
  no shutdown
exit

interface Port-channel3
  description Port-Channel to SW_Acceso_DMZ
  switchport trunk encapsulation dot1q
  switchport mode trunk
  no shutdown
exit

! --------------------------
! EtherChannel 4: SW_Acceso_LAN
! Puertos: Gi1/2 y Gi1/3
interface range GigabitEthernet1/2 - 3
  description EtherChannel to SW_Acceso_LAN
  switchport trunk encapsulation dot1q
  switchport mode trunk
  channel-group 4 mode active
  no shutdown
exit

interface Port-channel4
  description Port-Channel to SW_Acceso_LAN
  switchport trunk encapsulation dot1q
  switchport mode trunk
  no shutdown
exit

end
write memory
