import folium
from geopy.geocoders import Nominatim
import time

sites = [
    {"name": "Oficina central", "address": "Calle Ancha, Jerez de la Frontera, Spain", "coordenates": [36.68830069473355, -6.141331723620025]},
    {"name": "ETAP de Cuartillos", "address": "Cuartillos, Jerez de la Frontera, Spain", "coordenates": [36.677837, -6.008313] },
    {"name": "ETAP de Montañés", "address": "Carretera Puerto Real - Paterna, Spain", "coordenates": [36.520725003331606, -6.043437235454119]},
    {"name": "ETAP de Algar", "address": "Carretera de acceso a Algar, Cádiz, Spain", "coordenates": [36.65415095709361, -5.643843877011512] },
    {"name": "ETAP de Paterna", "address": "Paterna de Rivera, Cádiz, Spain", "coordenates": [36.527809, -5.863061]},
    {"name": "San Cristóbal", "address": "Antigua carretera Jerez - El Puerto, Spain", "coordenates": [36.645474914003536, -6.126661833443614]},
    {"name": "Depósito de Cádiz", "address": "Zona Franca, Cádiz, Spain", "coordenates": [36.5059990355522, -6.265044690365919]}
]

# Crea un objeto de mapa centrado en las coordenadas de la oficina central
map_sites = folium.Map(location=[36.6868, -6.1367], zoom_start=10)

# Añade un marcador al mapa usando las coordenadas de los datos del sitio
for site in sites:
    try:
        # Añade un marcador al mapa usando las coordenadas de los datos del sitio
        folium.Marker(
            location=site["coordenates"],
            popup=site["name"],
            tooltip=site["name"]
        ).add_to(map_sites)
        
        # Añade un marcador personalizado con el nombre del sitio
        folium.Marker(
            site["coordenates"],
            icon=folium.DivIcon(
                icon_size=(150, 36),
                icon_anchor=(75, 30),
                html=f'<div style="font-size: 12pt; font-weight: bold; text-align: center;">{site["name"]}</div>',
            )
        ).add_to(map_sites)
        
        print(f"Added marker for {site['name']} at {site['coordenates'][0]}, {site['coordenates'][1]}")
    except Exception as e:
        print(f"Error processing {site['name']}: {e}")

# Guarda el mapa en un archivo HTML
map_sites.save("sites_map.html")
print("Map saved to sites_map.html")