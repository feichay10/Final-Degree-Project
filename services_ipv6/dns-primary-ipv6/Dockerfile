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
RUN mkdir -p /etc/bind/zones /var/cache/bind /var/lib/bind

# Copiar archivos de configuración DNS
COPY named.conf.options /etc/bind/
COPY named.conf.local /etc/bind/
COPY zones/ /etc/bind/zones/

# Crear estructura de named.conf principal básica
RUN echo 'include "/etc/bind/named.conf.options";' > /etc/bind/named.conf && \
    echo 'include "/etc/bind/named.conf.local";' >> /etc/bind/named.conf && \
    echo 'include "/etc/bind/named.conf.default-zones";' >> /etc/bind/named.conf

# Establecer permisos correctos para bind
RUN chown -R bind:bind /etc/bind/zones /var/cache/bind /var/lib/bind
RUN chmod 755 /etc/bind/zones
RUN chmod 775 /var/cache/bind
RUN chmod 644 /etc/bind/named.conf.options /etc/bind/named.conf.local
RUN chmod 644 /etc/bind/zones/*

# Crear script de inicio
RUN echo '#!/bin/bash\n\
# Configurar IP IPv6 estática dinámicamente\n\
ip addr add 2001:db8:1234:0102::133/64 dev eth0\n\
echo "nameserver 2001:db8:1234:0102::133" > /etc/resolv.conf\n\
echo "nameserver 2001:db8:1234:0102::134" >> /etc/resolv.conf\n\
# Iniciar servidor DNS\n\
exec named -g -c /etc/bind/named.conf -u bind; exec bash' > /start.sh

RUN chmod +x /start.sh

# Exponer puertos DNS
EXPOSE 53/udp 53/tcp

# Comando por defecto
CMD ["/start.sh"] 