# DNS IPv6 - Configuración Básica y Sencilla

## 🎯 Configuración Mínima para Pruebas

Esta es una configuración DNS IPv6 **básica y sencilla** con solo lo esencial.

### ✅ Lo que INCLUYE:
- DNS primario y secundario IPv6
- Transferencia de zonas automática  
- TTL de 60 segundos para pruebas rápidas
- Resolución directa e inversa
- Solo servicios básicos de prueba

### 📋 Archivos de Configuración

```
dns-primary-ipv6/
├── Dockerfile                # Básico, sin logging
├── named.conf.options        # Solo opciones esenciales
├── named.conf.local          # 2 zonas: directa + inversa
└── zones/
    ├── db.cazg.es           # Zona principal (TTL 60s)
    └── db.2001.db8.1234.0102 # Zona inversa (TTL 60s)

dns-secondary-ipv6/
├── Dockerfile                # Básico, sin logging  
├── named.conf.options        # Configuración mínima
└── named.conf.local          # Zonas slave
```

### 🌐 Servicios Configurados

| Servicio | Hostname | IPv6 |
|----------|----------|------|
| DNS Primario | ns1.cazg.es | `2001:db8:1234:0102::133` |
| DNS Secundario | ns2.cazg.es | `2001:db8:1234:0102::134` |
| DHCP | dhcp.cazg.es | `2001:db8:1234:0102::132` |
| Test | test.cazg.es | `2001:db8:1234:0102::10` |
| Local | local.cazg.es | `2001:db8:1234:0102::20` |

### 🚀 Comandos

```bash
# Iniciar (reconstruir después de cambios)
docker-compose down && docker-compose up -d --build

# Validar
./validate_dns.sh

# Prueba básica
dig @2001:db8:1234:0102::133 AAAA test.cazg.es
```

---
**Configuración**: Básica y sencilla  
**Propósito**: Pruebas locales  
**Complejidad**: Mínima
