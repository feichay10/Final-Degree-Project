import folium
from geopy.geocoders import Nominatim
import time

# Site data from the table
sites = [
    {"name": "Oficina central", "address": "Calle Ancha, Jerez de la Frontera, Spain", "coordenates": [36.68830069473355, -6.141331723620025]},
    {"name": "ETAP de Cuartillos", "address": "Cuartillos, Jerez de la Frontera, Spain", "coordenates": [36.677837, -6.008313] },
    {"name": "ETAP de Montañés", "address": "Carretera Puerto Real - Paterna, Spain", "coordenates": [36.520725003331606, -6.043437235454119]},
    {"name": "ETAP de Algar", "address": "Carretera de acceso a Algar, Cádiz, Spain", "coordenates": [36.65415095709361, -5.643843877011512] },
    {"name": "ETAP de Paterna", "address": "Paterna de Rivera, Cádiz, Spain", "coordenates": [36.527809, -5.863061]},
    {"name": "San Cristóbal", "address": "Antigua carretera Jerez - El Puerto, Spain", "coordenates": [36.645474914003536, -6.126661833443614]},
    {"name": "Depósito de Cádiz", "address": "Zona Franca, Cádiz, Spain", "coordenates": [36.5059990355522, -6.265044690365919]}
]

# Create a map centered on Jerez de la Frontera
map_sites = folium.Map(location=[36.6868, -6.1367], zoom_start=10)

# Add markers for each site using the provided coordinates
for site in sites:
    try:
        # Add a marker to the map using the coordinates from the site data
        folium.Marker(
            location=site["coordenates"],
            popup=site["name"],
            tooltip=site["name"]
        ).add_to(map_sites)
        
        # Add a permanent label above the marker
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

# Find the central node (Oficina central)
central_node = None
for site in sites:
    if site["name"] == "Oficina central":
        central_node = site
        break

if central_node:
    # Define a list of distinct colors for the connections
    colors = ['red', 'blue', 'green', 'purple', 'orange', 'gray', 'yellow', 'pink']
    
    # Add connections from central node to all other sites (star topology)
    color_index = 0
    for site in sites:
        if site != central_node:  # Skip connecting to itself
            try:
                # Get a color from the list (cycling if needed)
                current_color = colors[color_index % len(colors)]
                color_index += 1
                
                # Create a line between central node and current site with unique color
                folium.PolyLine(
                    locations=[central_node["coordenates"], site["coordenates"]],
                    color=current_color,
                    weight=3,
                    opacity=0.8,
                    tooltip=f"{central_node['name']} - {site['name']}"
                ).add_to(map_sites)
                
                print(f"Added connection between {central_node['name']} and {site['name']} with color {current_color}")
            except Exception as e:
                print(f"Error creating connection: {e}")
else:
    print("Central node 'Oficina central' not found!")

# Save the map to an HTML file
map_sites.save("sites_map_graph.html")
print("Map saved to sites_map_graph.html")