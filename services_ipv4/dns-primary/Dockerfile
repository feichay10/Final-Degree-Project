FROM ubuntu:20.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar paquetes necesarios
RUN apt-get update && apt-get install -y \
    bind9 \
    bind9utils \
    bind9-doc \
    iputils-ping \
    net-tools \
    ifupdown \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios necesarios
RUN mkdir -p /etc/bind/zones /var/cache/bind /var/lib/bind /var/log/named

# Copiar archivos de configuración DNS
COPY named.conf.options /etc/bind/
COPY named.conf.local /etc/bind/
COPY zones/ /etc/bind/zones/

# Establecer permisos correctos para bind
RUN chown -R bind:bind /etc/bind/zones /var/cache/bind /var/lib/bind /var/log/named
RUN chmod 755 /etc/bind/zones
RUN chmod 775 /var/cache/bind
RUN chmod 644 /etc/bind/named.conf.options /etc/bind/named.conf.local
RUN chmod 644 /etc/bind/zones/*

# Crear script de inicio
RUN echo '#!/bin/bash\n\
# Configurar IP estática dinámicamente\n\
ip addr add 192.168.1.133/28 dev eth0\n\
ip route add default via 192.168.1.131\n\
echo "nameserver 192.168.1.133" > /etc/resolv.conf\n\
echo "nameserver 192.168.1.134" >> /etc/resolv.conf\n\
# Iniciar servidor DNS\n\
exec named -g -c /etc/bind/named.conf -u bind; exec bash' > /start.sh

RUN chmod +x /start.sh

# Exponer puertos DNS
EXPOSE 53/udp 53/tcp

# Comando por defecto
CMD ["/start.sh"] 