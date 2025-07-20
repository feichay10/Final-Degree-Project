#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Función para mostrar banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🗑️  LIMPIEZA DE DOCKER 🗑️                  ║"
    echo "║              Script para eliminar imágenes y contenedores    ║"
    echo "║                        Configuración IPv6                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Función para mostrar progreso
show_progress() {
    local message="$1"
    echo -e "${WHITE}➤ ${message}...${NC}"
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

# Función para confirmar acción
confirm_action() {
    echo -e "${YELLOW}"
    echo "⚠️  ATENCIÓN: Esta acción eliminará:"
    echo "   • Todos los contenedores del docker-compose"
    echo "   • Las imágenes: dhcp6-server, dns-primary, dns-secondary"
    echo "   • Configuración IPv6: 2001:db8:1234:0102::/64"
    echo -e "${NC}"
    
    while true; do
        read -p "¿Estás seguro de continuar? (s/n): " yn
        case $yn in
            [Ss]* ) return 0;;
            [Nn]* ) echo -e "${BLUE}Operación cancelada.${NC}"; exit 0;;
            * ) echo "Por favor responde 's' para sí o 'n' para no.";;
        esac
    done
}

# Función para verificar si Docker está ejecutándose
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        show_error "Docker no está ejecutándose o no tienes permisos para acceder a él"
        exit 1
    fi
}

# Función principal de limpieza
cleanup_docker() {
    show_progress "Deteniendo y eliminando contenedores con docker-compose"
    if docker-compose down; then
        show_success "Contenedores eliminados correctamente"
    else
        show_warning "No se pudieron detener algunos contenedores (puede que no estuvieran ejecutándose)"
    fi
    
    echo ""
    
    # Lista de imágenes a eliminar (actualizada para IPv6)
    images=("dhcp6-server:latest" "dns-primary:latest" "dns-secondary:latest")
    
    for image in "${images[@]}"; do
        show_progress "Eliminando imagen: ${image}"
        if docker rmi "${image}" 2>/dev/null; then
            show_success "Imagen ${image} eliminada"
        else
            show_warning "La imagen ${image} no existe o no se pudo eliminar"
        fi
    done
    
    echo ""
    show_progress "Eliminando imágenes huérfanas y contenedores detenidos"
    docker system prune -f >/dev/null 2>&1
    show_success "Limpieza adicional completada"
}

# Función para mostrar resumen final
show_summary() {
    echo ""
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🎉 LIMPIEZA COMPLETADA 🎉                 ║"
    echo "║                        Configuración IPv6                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}📊 Resumen del estado actual:${NC}"
    echo ""
    
    # Mostrar contenedores activos
    echo -e "${WHITE}Contenedores activos:${NC}"
    if [ "$(docker ps -q)" ]; then
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        echo -e "${GREEN}   ✅ No hay contenedores ejecutándose${NC}"
    fi
    
    echo ""
    
    # Mostrar imágenes restantes
    echo -e "${WHITE}Imágenes del proyecto IPv6:${NC}"
    project_images=$(docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep -E "(dhcp6-server|dns-primary|dns-secondary)" || echo "")
    if [ -z "$project_images" ]; then
        echo -e "${GREEN}   ✅ Todas las imágenes del proyecto IPv6 han sido eliminadas${NC}"
    else
        echo "$project_images"
    fi
}

# Script principal
main() {
    clear
    show_banner
    
    check_docker
    confirm_action
    
    echo ""
    cleanup_docker
    show_summary
    
    echo ""
    echo -e "${GREEN}🚀 ¡Listo para reconstruir los servicios IPv6!${NC}"
    echo -e "${BLUE}💡 Usa 'docker-compose up --build' para reconstruir los servicios${NC}"
    echo ""
}

# Ejecutar script principal
main
