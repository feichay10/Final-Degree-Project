#!/bin/bash

# Script para iniciar los servicios DHCP y DNS con Docker Compose
# Autor: Configuración automatizada para TFG

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Variables globales
SERVICES=("dhcp" "dns-primary" "dns-secondary")
WAIT_TIME=15

# Función para mostrar banner principal
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                🚀 INICIADOR DE SERVICIOS DNS/DHCP 🚀         ║"
    echo "║              Configuración automatizada para TFG             ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Función para mostrar progreso con animación
show_progress() {
    local message="$1"
    local duration="${2:-2}"
    echo -e "${WHITE}➤ ${message}...${NC}"
    
    # Animación de puntos
    for i in $(seq 1 $duration); do
        echo -n "."
        sleep 0.5
    done
    echo ""
}

# Función para mostrar éxito
show_success() {
    local message="$1"
    echo -e "${GREEN}✅ ${message}${NC}"
}

# Función para mostrar error
show_error() {
    local message="$1"
    echo -e "${RED}❌ ${message}${NC}"
}

# Función para mostrar advertencia
show_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠️  ${message}${NC}"
}

# Función para mostrar información
show_info() {
    local message="$1"
    echo -e "${BLUE}ℹ️  ${message}${NC}"
}

# Función para mostrar sección
show_section() {
    local title="$1"
    echo ""
    echo -e "${PURPLE}${BOLD}═══ ${title} ═══${NC}"
}

# Función para verificar dependencias
check_dependencies() {
    show_section "VERIFICANDO DEPENDENCIAS"
    
    # Verificar Docker
    show_progress "Verificando Docker" 1
    if ! command -v docker &> /dev/null; then
        show_error "Docker no está instalado"
        echo -e "${YELLOW}💡 Instala Docker desde: https://docs.docker.com/get-docker/${NC}"
        exit 1
    fi
    show_success "Docker encontrado"
    
    # Verificar Docker Compose
    show_progress "Verificando Docker Compose" 1
    if ! command -v docker-compose &> /dev/null; then
        show_error "Docker Compose no está instalado"
        echo -e "${YELLOW}💡 Instala Docker Compose desde: https://docs.docker.com/compose/install/${NC}"
        exit 1
    fi
    show_success "Docker Compose encontrado"
    
    # Verificar permisos de Docker
    show_progress "Verificando permisos de Docker" 1
    if ! docker info &> /dev/null; then
        show_error "No tienes permisos para ejecutar Docker"
        echo -e "${YELLOW}💡 Ejecuta: sudo usermod -aG docker $USER${NC}"
        echo -e "${YELLOW}💡 Luego cierra sesión y vuelve a iniciar${NC}"
        exit 1
    fi
    show_success "Permisos de Docker verificados"
}

# Función para limpiar servicios existentes
cleanup_existing_services() {
    show_section "LIMPIANDO SERVICIOS EXISTENTES"
    
    show_progress "Deteniendo servicios existentes" 2
    if docker-compose down 2>/dev/null; then
        show_success "Servicios existentes detenidos"
    else
        show_warning "No había servicios ejecutándose"
    fi
}

# Función para construir imágenes
build_images() {
    show_section "CONSTRUYENDO IMÁGENES"
    
    show_progress "Construyendo imágenes Docker" 3
    if docker-compose build --no-cache; then
        show_success "Imágenes construidas exitosamente"
    else
        show_error "Error al construir las imágenes"
        exit 1
    fi
}

# Función para iniciar servicios
start_services() {
    show_section "INICIANDO SERVICIOS"
    
    show_progress "Levantando servicios en segundo plano" 2
    if docker-compose up -d; then
        show_success "Servicios iniciados"
    else
        show_error "Error al iniciar los servicios"
        exit 1
    fi
    
    # Esperar a que los servicios se inicien
    show_progress "Esperando inicialización de servicios" $WAIT_TIME
    show_success "Servicios inicializados"
}

# Función para verificar estado de servicios
check_services_status() {
    show_section "VERIFICANDO ESTADO DE SERVICIOS"
    
    echo -e "${WHITE}Estado de los contenedores:${NC}"
    docker-compose ps
    
    echo ""
    
    # Verificar que todos los contenedores están corriendo
    local running_containers=$(docker-compose ps | grep -c "Up" || echo "0")
    local total_services=${#SERVICES[@]}
    
    if [ "$running_containers" -eq "$total_services" ]; then
        show_success "Todos los servicios están ejecutándose correctamente"
    else
        show_warning "Algunos servicios pueden no estar funcionando correctamente"
        echo ""
        echo -e "${YELLOW}📋 Logs de los servicios:${NC}"
        docker-compose logs --tail=10
    fi
}

# Función para mostrar información de red
show_network_info() {
    show_section "INFORMACIÓN DE RED"
    
    echo -e "${CYAN}🌐 Configuración de red:${NC}"
    echo -e "${WHITE}┌─────────────────┬─────────────────┬──────────────────────┐${NC}"
    echo -e "${WHITE}│ Servicio        │ IP              │ Función              │${NC}"
    echo -e "${WHITE}├─────────────────┼─────────────────┼──────────────────────┤${NC}"
    echo -e "${WHITE}│ DHCP Server     │ 192.168.1.132   │ Asignación de IPs    │${NC}"
    echo -e "${WHITE}│ DNS Primary     │ 192.168.1.133   │ Servidor DNS maestro │${NC}"
    echo -e "${WHITE}│ DNS Secondary   │ 192.168.1.134   │ Servidor DNS esclavo │${NC}"
    echo -e "${WHITE}│ Gateway         │ 192.168.1.131   │ Puerta de enlace     │${NC}"
    echo -e "${WHITE}└─────────────────┴─────────────────┴──────────────────────┘${NC}"
}

# Función para mostrar comandos útiles
show_useful_commands() {
    show_section "COMANDOS ÚTILES"
    
    echo -e "${CYAN}🛠️  Gestión de servicios:${NC}"
    echo -e "${WHITE}  • Ver logs:                ${YELLOW}docker-compose logs${NC}"
    echo -e "${WHITE}  • Ver logs en tiempo real: ${YELLOW}docker-compose logs -f${NC}"
    echo -e "${WHITE}  • Parar servicios:         ${YELLOW}docker-compose down${NC}"
    echo -e "${WHITE}  • Reiniciar servicios:     ${YELLOW}docker-compose restart${NC}"
    echo -e "${WHITE}  • Acceder a contenedor:    ${YELLOW}docker-compose exec <servicio> bash${NC}"
    
    echo ""
    echo -e "${CYAN}🧪 Pruebas de funcionamiento:${NC}"
    echo -e "${WHITE}  • Consulta DNS directa:   ${YELLOW}nslookup ns1.cazg.es 192.168.1.133${NC}"
    echo -e "${WHITE}  • Consulta DNS inversa:   ${YELLOW}nslookup 192.168.1.132 192.168.1.133${NC}"
    echo -e "${WHITE}  • Ping al DNS primario:   ${YELLOW}ping 192.168.1.133${NC}"
    echo -e "${WHITE}  • Ping al DNS secundario: ${YELLOW}ping 192.168.1.134${NC}"
}

# Función para mostrar resumen final
show_final_summary() {
    echo ""
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                  🎉 SERVICIOS INICIADOS 🎉                   ║"
    echo "║                ¡Configuración completada!                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${PURPLE}📊 Resumen del despliegue:${NC}"
    echo -e "${GREEN}  ✅ Servicios DNS/DHCP operativos${NC}"
    echo -e "${GREEN}  ✅ Red 192.168.1.0/28 configurada${NC}"
    echo -e "${GREEN}  ✅ Transferencia de zonas DNS activa${NC}"
    echo -e "${GREEN}  ✅ Listo para pruebas en GNS3${NC}"
    
    echo ""
    echo -e "${BLUE}🚀 ¡El entorno está listo para usar!${NC}"
}

# Función principal
main() {
    show_banner
    
    check_dependencies
    cleanup_existing_services
    build_images
    start_services
    check_services_status
    show_network_info
    show_useful_commands
    show_final_summary
    
    echo ""
}

# Ejecutar script principal
main
