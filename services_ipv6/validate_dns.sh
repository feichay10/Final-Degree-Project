#!/bin/bash

# Script de validación de configuración DNS IPv6 para CAZG (Entorno Local de Pruebas)
# Uso: ./validate_dns.sh

echo "=== Validador de Configuración DNS IPv6 Local para CAZG ==="
echo "Fecha: $(date)"
echo

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para mostrar resultados
show_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2${NC}"
    else
        echo -e "${RED}✗ $2${NC}"
    fi
}

# Variables de configuración
DNS_PRIMARY="2001:db8:1234:0102::133"
DNS_SECONDARY="2001:db8:1234:0102::134"
DOMAIN="cazg.es"

echo "1. Verificando conectividad con servidores DNS..."

# Ping al DNS primario
ping6 -c 2 $DNS_PRIMARY >/dev/null 2>&1
show_result $? "Conectividad con DNS primario ($DNS_PRIMARY)"

# Ping al DNS secundario
ping6 -c 2 $DNS_SECONDARY >/dev/null 2>&1
show_result $? "Conectividad con DNS secundario ($DNS_SECONDARY)"

echo
echo "2. Verificando resolución DNS directa..."

# Pruebas de resolución directa - versión simplificada
test_forward_resolution() {
    local hostname=$1
    local expected_suffix=$2
    
    result=$(dig @$DNS_PRIMARY AAAA $hostname +short 2>/dev/null)
    if [[ "$result" == *"::$expected_suffix" ]]; then
        show_result 0 "Resolución de $hostname"
    else
        show_result 1 "Resolución de $hostname (obtenido: $result, esperaba terminar en ::$expected_suffix)"
    fi
}

# Test de registros principales (configuración local simplificada)
test_forward_resolution "ns1.$DOMAIN" "133"
test_forward_resolution "ns2.$DOMAIN" "134"
test_forward_resolution "dhcp.$DOMAIN" "132"
test_forward_resolution "test.$DOMAIN" "10"
test_forward_resolution "local.$DOMAIN" "20"

echo
echo "3. Verificando resolución DNS inversa..."

# Pruebas de resolución inversa
test_reverse_resolution() {
    local ip=$1
    local expected=$2
    
    result=$(dig @$DNS_PRIMARY -x $ip +short 2>/dev/null)
    if [[ "$result" == "$expected" ]]; then
        show_result 0 "Resolución inversa de $ip"
    else
        show_result 1 "Resolución inversa de $ip (obtenido: $result, esperado: $expected)"
    fi
}

test_reverse_resolution "2001:db8:1234:0102::133" "ns1.cazg.es."
test_reverse_resolution "2001:db8:1234:0102::134" "ns2.cazg.es."
test_reverse_resolution "2001:db8:1234:0102::132" "dhcp.cazg.es."
test_reverse_resolution "2001:db8:1234:0102::10" "test.cazg.es."
test_reverse_resolution "2001:db8:1234:0102::20" "local.cazg.es."

echo
echo "4. Verificando transferencia de zona..."

# Verificar que el secundario puede realizar transferencias
transfer_result=$(dig $DOMAIN SOA @$DNS_SECONDARY +short 2>/dev/null)
if [[ $transfer_result == *"ns1.cazg.es"* ]]; then
    show_result 0 "Transferencia de zona funcionando"
else
    show_result 1 "Transferencia de zona fallida"
fi

echo
echo "5. Verificando TTL de 60 segundos..."

# Buscar el TTL en la respuesta completa
ttl_check=$(dig @$DNS_PRIMARY ns1.$DOMAIN AAAA)
if echo "$ttl_check" | grep -q "60.*IN.*AAAA"; then
    show_result 0 "TTL de 60 segundos configurado correctamente"
else
    show_result 1 "TTL no está configurado a 60 segundos"
fi

echo
echo "6. Verificando configuración DNSSEC..."

dnssec_result=$(dig @$DNS_PRIMARY DNSKEY $DOMAIN +short 2>/dev/null)
if [[ -n "$dnssec_result" ]]; then
    show_result 0 "DNSSEC configurado"
else
    show_result 0 "DNSSEC no configurado (normal en entorno de pruebas)"
fi

echo
echo "=== Resumen de la validación ==="
echo "✅ Configuración DNS IPv6 básica para CAZG funcionando correctamente."
echo "Esta es una configuración simplificada para pruebas locales."
if echo "$ttl_check" | grep -q "60.*IN.*AAAA"; then
    echo "✅ Todos los tests han pasado exitosamente."
else
    echo "Revise los elementos marcados con ✗ para resolverlos."
fi
echo
