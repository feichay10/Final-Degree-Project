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
RUN touch /var/lib/dhcp/dhcpd.leases

# Establecer permisos correctos
RUN chown -R dhcpd:dhcpd /var/lib/dhcp /var/log
RUN chmod 644 /var/lib/dhcp/dhcpd.leases

# Copiar archivos de configuración del DHCP
COPY dhcpd.conf /etc/dhcp/dhcpd.conf
COPY isc-dhcp-server /etc/default/isc-dhcp-server

# Establecer permisos correctos para los archivos de configuración
RUN chmod 644 /etc/dhcp/dhcpd.conf
RUN chmod 644 /etc/default/isc-dhcp-server

# Crear script de inicio
RUN echo '#!/bin/bash\n\
# Configurar IP estática dinámicamente\n\
ip addr add 192.168.1.132/28 dev eth0\n\
ip route add default via 192.168.1.131\n\
echo "nameserver 192.168.1.133" > /etc/resolv.conf\n\
echo "nameserver 192.168.1.134" >> /etc/resolv.conf\n\
# Iniciar servidor DHCP\n\
exec dhcpd -4 -cf /etc/dhcp/dhcpd.conf -d eth0; exec bash' > /start.sh

RUN chmod +x /start.sh

# Crear usuario dhcpd si no existe
RUN useradd -r -s /bin/false dhcpd 2>/dev/null || true

# Exponer puerto DHCP
EXPOSE 67/udp

# Usar el script de inicio
CMD ["/start.sh"] 