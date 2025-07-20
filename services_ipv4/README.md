# 🚀 Servicios DNS/DHCP Dockerizados para GNS3

## 📋 Descripción del Proyecto

Este proyecto proporciona una solución completa y automatizada para desplegar servicios de red esenciales (DNS y DHCP) como contenedores Docker optimizados para su uso en GNS3. La implementación incluye un servidor DHCP y una infraestructura DNS con alta disponibilidad (primario y secundario), todo preconfigurado y listo para usar.

### 🎯 Objetivos Principales

- **Simplificar** la configuración de servicios de red en GNS3
- **Optimizar** el uso de recursos mediante contenedores Docker ligeros
- **Automatizar** el despliegue y gestión de servicios
- **Proporcionar** alta disponibilidad con DNS primario y secundario
- **Facilitar** la integración en topologías de red complejas

## ✨ Características Principales

### 🐳 **Contenedores Docker Optimizados**
- Imágenes ligeras basadas en Ubuntu 20.04
- Configuración automática de red
- Inicio automático de servicios
- Scripts de diagnóstico integrados

### 🌐 **Infraestructura DNS Completa**
- **DNS Primario**: Servidor maestro con zonas configuradas
- **DNS Secundario**: Servidor esclavo con transferencia automática de zonas
- **Resolución directa e inversa**: Para el dominio `cazg.es`
- **Forwarders externos**: Google DNS (8.8.8.8) y Cloudflare (1.1.1.1)

### 📡 **Servidor DHCP Multi-VLAN**
- Soporte para múltiples VLANs (Datos, Voz, DMZ)
- Configuración de pools dinámicos
- Asignación automática de DNS servers
- Gestión de arrendamientos

### 🛠️ **Scripts de Automatización**
- **`start.sh`**: Script para iniciar todos los servicios
- **`delete_images.sh`**: Script para limpiar imágenes y contenedores

## 📁 Estructura del Proyecto

```
services/
├── 📄 docker-compose.yml          # Orquestación de servicios
├── 🚀 start.sh                    # Script de inicio automatizado
├── 🗑️ delete_images.sh            # Script de limpieza
├── 📖 README.md                   # Esta documentación
├── 📁 dhcp/                       # Servidor DHCP
│   ├── 🐳 Dockerfile              # Imagen Ubuntu + ISC-DHCP-Server
│   ├── ⚙️ dhcpd.conf              # Configuración DHCP multi-VLAN
│   └── 🔧 isc-dhcp-server         # Configuración de interfaces
├── 📁 dns-primary/                # Servidor DNS Primario
│   ├── 🐳 Dockerfile              # Imagen Ubuntu + BIND9
│   ├── ⚙️ named.conf.options      # Opciones globales BIND
│   ├── ⚙️ named.conf.local        # Zonas locales (master)
│   └── 📁 zones/                  # Archivos de zona DNS
│       ├── 🌐 db.cazg.es          # Zona directa (nombre → IP)
│       └── 🌐 db.192.168.1        # Zona inversa (IP → nombre)
└── 📁 dns-secondary/              # Servidor DNS Secundario
    ├── 🐳 Dockerfile              # Imagen Ubuntu + BIND9
    ├── ⚙️ named.conf.options      # Opciones globales BIND
    ├── ⚙️ named.conf.local        # Configuración slave
    └── 📁 zones/                  # Directorio para zonas transferidas
```

## 🌐 Arquitectura de Red

### Topología de Red Implementada

```
┌─────────────────────────────────────────────────────────────────┐
│                      🌐 Red Corporativa                         │
├─────────────────────────────────────────────────────────────────┤
│ VLAN 10 (Datos): 192.168.1.0/26                                 │   
│  ├─ Gateway: 192.168.1.1                                        │
│  └─ Pool DHCP: 192.168.1.2 - 192.168.1.62                       │
├─────────────────────────────────────────────────────────────────┤
│ VLAN 20 (Voz): 192.168.1.64/26                                  │
│  ├─ Gateway: 192.168.1.65                                       │
│  └─ Pool DHCP: 192.168.1.66 - 192.168.1.126                     │
├─────────────────────────────────────────────────────────────────┤
│ VLAN 30 (DMZ): 192.168.1.128/28                                 │
│  ├─ Gateway: 192.168.1.129                                      │
│  ├─ DHCP Server: 192.168.1.130                                  │
│  ├─ DNS Primary: 192.168.1.131                                  │
│  └─ DNS Secondary: 192.168.1.132                                │
└─────────────────────────────────────────────────────────────────┘
```

### 📋 Tabla de Direcciones IP

| Servicio | IP | Hostname | Descripción |
|-------------|-------|-------------|----------------|
| Gateway DMZ | 192.168.1.129 | gateway | Puerta de enlace del segmento DMZ |
| DHCP Server | 192.168.1.130 | dhcp.cazg.es | Gestiona asignación de IPs para todas las VLANs |
| DNS Primary | 192.168.1.131 | ns1.cazg.es | Servidor DNS maestro para el dominio cazg.es |
| DNS Secondary | 192.168.1.132 | ns2.cazg.es | Servidor DNS esclavo con alta disponibilidad |

### 🔌 Puertos de Servicio

| Servicio | Puerto Host | Puerto Contenedor | Protocolo | Descripción |
|-------------|---------------|---------------------|-------------|----------------|
| DHCP Server | - | 67 | UDP | Asignación de direcciones IP |
| DNS Primary | 5353 | 53 | UDP/TCP | Consultas DNS primarias |
| DNS Secondary | 5454 | 53 | UDP/TCP | Consultas DNS secundarias |

## 🐳 Configuración Docker

### docker-compose.yml

El archivo de orquestación define tres servicios principales:

```yaml
services:
  dhcp-server:
    build: ./dhcp
    container_name: dhcp_server
    networks:
      dmz_network:
        ipv4_address: 192.168.1.130
    
  dns-primary:
    build: ./dns-primary
    container_name: dns_primary_server
    networks:
      dmz_network:
        ipv4_address: 192.168.1.131
    
  dns-secondary:
    build: ./dns-secondary
    container_name: dns_secondary_server
    depends_on:
      - dns-primary
    networks:
      dmz_network:
        ipv4_address: 192.168.1.132
```

### 🐳 Dockerfiles Optimizados

#### 📡 DHCP Server (`dhcp/Dockerfile`)
- **Base**: Ubuntu 20.04 LTS
- **Servicios**: ISC-DHCP-Server
- **Características**:
  - Configuración automática de IP estática
  - Creación automática de archivo de leases
  - Permisos optimizados para usuario dhcpd
  - Script de inicio con diagnósticos

#### 🌐 DNS Primary (`dns-primary/Dockerfile`)
- **Base**: Ubuntu 20.04 LTS
- **Servicios**: BIND9, bind9utils
- **Características**:
  - Configuración como servidor maestro
  - Zonas DNS preconfiguradas
  - Transferencia de zonas habilitada
  - Script de inicio con validaciones

#### 🌐 DNS Secondary (`dns-secondary/Dockerfile`)
- **Base**: Ubuntu 20.04 LTS
- **Servicios**: BIND9, bind9utils
- **Características**:
  - Configuración como servidor esclavo
  - Transferencia automática de zonas
  - Conectividad con DNS primario
  - Script de inicio con diagnósticos mejorados

## ⚙️ Configuración de Servicios

### 📡 Servidor DHCP

#### Configuración Principal (`dhcp/dhcpd.conf`)

```bash
# Configuración global
default-lease-time 600;         # 10 minutos
max-lease-time 7200;           # 2 horas
authoritative;
option domain-name "cazg.es";
option domain-name-servers 192.168.1.131, 192.168.1.132;

# VLAN 10 - Red de Datos
subnet 192.168.1.0 netmask 255.255.255.192 {
    range 192.168.1.2 192.168.1.62;
    option routers 192.168.1.1;
}

# VLAN 20 - Red de Voz
subnet 192.168.1.64 netmask 255.255.255.192 {
    range 192.168.1.66 192.168.1.126;
    option routers 192.168.1.65;
}

# VLAN 30 - DMZ (sin pool dinámico)
subnet 192.168.1.128 netmask 255.255.255.240 {
    option routers 192.168.1.129;
}
```

### 🌐 Servidor DNS Primario

#### Opciones Globales (`dns-primary/named.conf.options`)

```bash
options {
    directory "/var/cache/bind";
    listen-on { 192.168.1.131; };
    allow-query { any; };
    forwarders {
        8.8.8.8;    # Google DNS
        1.1.1.1;    # Cloudflare DNS
    };
    recursion yes;
    dnssec-validation auto;
    auth-nxdomain no;
};
```

#### Zonas Locales (`dns-primary/named.conf.local`)

```bash
// Zona directa
zone "cazg.es" {
    type master;
    file "/etc/bind/zones/db.cazg.es";
    allow-transfer { 192.168.1.132; };
};

// Zona inversa
zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.1";
    allow-transfer { 192.168.1.132; };
};
```

#### Zona Directa (`dns-primary/zones/db.cazg.es`)

```dns
$TTL    60
@       IN      SOA     ns1.cazg.es. admin.cazg.es. (
                        2025051001  ; Serial
                        60          ; Refresh
                        60          ; Retry
                        60          ; Expire
                        60 )        ; TTL

        IN      NS      ns1.cazg.es.
        IN      NS      ns2.cazg.es.
ns1     IN      A       192.168.1.131
ns2     IN      A       192.168.1.132
dhcp    IN      A       192.168.1.130
```

### 🌐 Servidor DNS Secundario

#### Configuración Slave (`dns-secondary/named.conf.local`)

```bash
// Zona directa (slave)
zone "cazg.es" {
    type slave;
    file "/etc/bind/zones/db.cazg.es";
    masters { 192.168.1.131; };
};

// Zona inversa (slave)
zone "1.168.192.in-addr.arpa" {
    type slave;
    file "/etc/bind/zones/db.192.168.1";
    masters { 192.168.1.131; };
};
```

## 🚀 Scripts de Automatización

### Script de Inicio (`start.sh`)

Script para iniciar todos los servicios:

#### 🔧 Funcionalidades
- ✅ Verificación de dependencias (Docker, Docker Compose)
- ✅ Validación de permisos
- ✅ Limpieza de servicios existentes
- ✅ Construcción de imágenes con `--no-cache`
- ✅ Inicio de servicios en segundo plano
- ✅ Verificación de estado de contenedores
- ✅ Información de red y comandos útiles
- ✅ Resumen final del despliegue

#### 📋 Ejemplo de Uso
```bash
./start.sh
```

### Script de Limpieza (`delete_images.sh`)

Script para limpiar imágenes y contenedores:

#### 🔧 Funcionalidades
- ✅ Verificación de Docker activo
- ✅ Confirmación interactiva del usuario
- ✅ Detención de contenedores con docker-compose
- ✅ Eliminación de imágenes específicas del proyecto
- ✅ Limpieza de imágenes huérfanas
- ✅ Resumen del estado final

#### 📋 Ejemplo de Uso
```bash
./delete_images.sh
```

## 🚀 Guía de Uso

### 1. 📥 Preparación del Entorno

```bash
# Clonar o descargar el proyecto
cd /ruta/al/proyecto/services

# Verificar que Docker y Docker Compose están instalados
docker --version
docker-compose --version
```

### 2. 🏗️ Construcción e Inicio

```bash
# Opción 1: Usar el script automatizado (recomendado)
./start.sh

# Opción 2: Usar docker-compose directamente
docker-compose up --build -d
```

### 3. ✅ Verificación de Servicios

```bash
# Ver estado de contenedores
docker-compose ps

# Ver logs de todos los servicios
docker-compose logs

# Ver logs de un servicio específico
docker-compose logs dns-primary
```

### 4. 🧪 Pruebas de Funcionamiento

#### Pruebas DNS
```bash
# Consulta directa al DNS primario
nslookup ns1.cazg.es 192.168.1.131

# Consulta directa al DNS secundario
nslookup ns2.cazg.es 192.168.1.132

# Consulta inversa
nslookup 192.168.1.130 192.168.1.131

# Verificar transferencia de zona
dig @192.168.1.132 cazg.es AXFR
```

#### Pruebas de Conectividad
```bash
# Ping a los servidores
ping 192.168.1.130  # DHCP
ping 192.168.1.131  # DNS Primary
ping 192.168.1.132  # DNS Secondary
```

### 5. 🔧 Gestión de Servicios

```bash
# Parar servicios
docker-compose down

# Reiniciar servicios
docker-compose restart

# Acceder a un contenedor
docker-compose exec dns-primary bash

# Ver logs en tiempo real
docker-compose logs -f
```

### 6. 🗑️ Limpieza

```bash
# Usar script de limpieza (recomendado)
./delete_images.sh

# Limpieza manual
docker-compose down
docker rmi dhcp_server:latest dns_primary_server:latest dns_secondary_server:latest
```

## 🔧 Integración con GNS3

### 1. 📥 Importar Contenedores

1. **Construir las imágenes** usando `./start.sh`
2. **Abrir GNS3** y ir a `Edit → Preferences`
3. **Seleccionar Docker containers** en el panel izquierdo
4. **Hacer clic en "New"** para añadir un nuevo template
5. **Seleccionar las imágenes**:
   - `dhcp_server:latest`
   - `dns_primary_server:latest`
   - `dns_secondary_server:latest`

### 2. 🌐 Configuración de Red en GNS3

1. **Crear la topología** con switches y routers
2. **Configurar VLANs** en los switches:
   - VLAN 10: Red de datos
   - VLAN 20: Red de voz
   - VLAN 30: DMZ
3. **Conectar los contenedores** a la VLAN 30 (DMZ)
4. **Configurar routing** entre VLANs en el router

### 3. ⚙️ Configuración de Interfaces

En GNS3, configurar las interfaces de los contenedores:
- **DHCP Server**: Conectar a VLAN 30
- **DNS Primary**: Conectar a VLAN 30
- **DNS Secondary**: Conectar a VLAN 30

## 🔍 Solución de Problemas

### ❌ Problemas Comunes

#### 1. **Contenedores no inician**
```bash
# Verificar logs
docker-compose logs

# Verificar permisos de Docker
sudo usermod -aG docker $USER
# Cerrar sesión y volver a iniciar
```

#### 2. **DNS no resuelve**
```bash
# Verificar configuración de zonas
docker-compose exec dns-primary named-checkconf
docker-compose exec dns-primary named-checkzone cazg.es /etc/bind/zones/db.cazg.es

# Verificar transferencia de zona
docker-compose exec dns-secondary dig @192.168.1.131 cazg.es AXFR
```

#### 3. **DHCP no asigna IPs**
```bash
# Verificar configuración DHCP
docker-compose exec dhcp-server dhcpd -t -cf /etc/dhcp/dhcpd.conf

# Verificar logs DHCP
docker-compose logs dhcp-server
```

#### 4. **Problemas de conectividad**
```bash
# Verificar configuración de red
docker network ls
docker network inspect services_dmz_network

# Verificar IPs asignadas
docker-compose exec dns-primary ip addr show
```

### 🛠️ Comandos de Diagnóstico

```bash
# Estado general del sistema
docker system df
docker system info

# Información de red
docker network ls
docker network inspect services_dmz_network

# Logs detallados
docker-compose logs --tail=50 --timestamps

# Acceso a contenedores para diagnóstico
docker-compose exec dhcp-server bash
docker-compose exec dns-primary bash
docker-compose exec dns-secondary bash
```

## 📚 Recursos Adicionales

### 📖 Documentación de Referencia

- **Docker**: https://docs.docker.com/
- **Docker Compose**: https://docs.docker.com/compose/
- **BIND9**: https://bind9.readthedocs.io/
- **ISC DHCP**: https://www.isc.org/dhcp/
- **GNS3**: https://docs.gns3.com/

## 🏆 Créditos

Desarrollado como parte del Trabajo de Fin de Grado (TFG) para la implementación de servicios de red automatizados en entornos de simulación GNS3.
