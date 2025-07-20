$TTL    60
@       IN      SOA     ns1.cazg.es. admin.cazg.es. (
                        2025070102         ; Serial 
                        60                 ; Refresh
                        60                 ; Retry
                        60                 ; Expire
                        60 )               ; TTL mínimo

; Servidores de nombres
        IN      NS      ns1.cazg.es.
        IN      NS      ns2.cazg.es.

; Servidores DNS e infraestructura local
ns1     IN      AAAA    2001:db8:1234:0102::133
ns2     IN      AAAA    2001:db8:1234:0102::134
dhcp    IN      AAAA    2001:db8:1234:0102::132

; Servicios básicos locales para pruebas
test    IN      AAAA    2001:db8:1234:0102::10
local   IN      AAAA    2001:db8:1234:0102::20 
