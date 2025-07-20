FROM ubuntu:20.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar paquetes necesarios
RUN apt-get update && apt-get install -y \
    isc-dhcp-server \
    iputils-ping \
    net-tools \
    iproute2 \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio para logs y leases
RUN mkdir -p /var/log /var/lib/dhcp /var/run

# Crear archivo de leases inicial (requerido por dhcpd)
RUN touch /var/lib/dhcp/dhcpd6.leases

# Establecer permisos correctos
RUN chown -R dhcpd:dhcpd /var/lib/dhcp /var/log
RUN chmod 644 /var/lib/dhcp/dhcpd6.leases

# Copiar archivos de configuración del DHCP
COPY dhcpd6.conf /etc/dhcp/dhcpd6.conf
COPY isc-dhcp-server /etc/default/isc-dhcp-server

# Establecer permisos correctos para los archivos de configuración
RUN chmod 644 /etc/dhcp/dhcpd6.conf
RUN chmod 644 /etc/default/isc-dhcp-server

# Crear script de inicio
RUN echo '#!/bin/bash\n\
# Configurar IP estática dinámicamente\n\
ip -6 addr add 2001:db8:1234:0102::132/64 dev eth0\n\
ip -6 route add default via 2001:db8:1234:0102::1\n\
echo "nameserver 2001:db8:1234:0102::133" > /etc/resolv.conf\n\
echo "nameserver 2001:db8:1234:0102::134" >> /etc/resolv.conf\n\
# Iniciar servidor DHCP\n\
exec dhcpd -6 -cf /etc/dhcp/dhcpd6.conf -d eth0; exec bash' > /start.sh

RUN chmod +x /start.sh

# Crear usuario dhcpd si no existe
RUN useradd -r -s /bin/false dhcpd 2>/dev/null || true

# Exponer puerto DHCP
EXPOSE 547/udp

# Usar el script de inicio
CMD ["/start.sh"] 
