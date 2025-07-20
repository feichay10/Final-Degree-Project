$TTL    60
@       IN      SOA     ns1.cazg.es. admin.cazg.es. (
                        2025051001         ; Serial
                        60                 ; Refresh
                        60                 ; Retry
                        60                 ; Expire
                        60 )               ; TTL

        IN      NS      ns1.cazg.es.
        IN      NS      ns2.cazg.es.
ns1     IN      A       192.168.1.133
ns2     IN      A       192.168.1.134
dhcp    IN      A       192.168.1.132 
