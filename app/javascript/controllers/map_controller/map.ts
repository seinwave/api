import mapboxgl from 'mapbox-gl';
import type { Map } from 'mapbox-gl';
import { fetchPlants, routeToInfoPanel } from '../api';

function fetchMap() {
  const accessToken =
    'pk.eyJ1IjoibXNlaWRob2x6IiwiYSI6ImNsbnRkcmU1bDAyZmsycW8wdm94dmlsazEifQ.73QWWjTn7i9A0xsesKLqeQ';
  mapboxgl.accessToken = accessToken;
  const map = new mapboxgl.Map({
    container: 'map-container',
    style: 'mapbox://styles/mapbox/light-v11',
    center: [-73.96527, 40.66911],
    zoom: 19,
    bearing: 14,
  });

  return map;
}

function generateMarkers(map: Map) {
  const roseIcon = new Image();
  const mapContainer = document.getElementById('map-container');
  const roseIconPath = mapContainer && mapContainer.dataset.roseIconPath;

  roseIcon.src = roseIconPath || '';
  map.on('load', async () => {
    map.addImage('rose-icon', roseIcon);

    const plantData = await fetchPlants();

    const geoJsonFeatures: Array<
      GeoJSON.Feature<GeoJSON.Point, GeoJSON.GeoJsonProperties>
    > = plantData.map((plant) => ({
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [plant.longitude, plant.latitude],
      },
      properties: {
        id: plant.id,
        cultivar_id: plant.cultivar_id,
        cultivar_name: plant.cultivar_name,
      },
    }));

    const featureCollection: GeoJSON.FeatureCollection<
      GeoJSON.Point,
      GeoJSON.GeoJsonProperties
    > = {
      type: 'FeatureCollection',
      features: geoJsonFeatures,
    };

    map.addSource('plants-source', {
      type: 'geojson',
      data: featureCollection,
    });

    map.addLayer({
      id: 'custom-marker-layer',
      type: 'symbol',
      source: 'plants-source',
      layout: {
        'icon-image': 'rose-icon',
        'icon-size': ['interpolate', ['linear'], ['zoom'], 0, 0.005, 22, 0.05],
        'icon-allow-overlap': false,
        'text-field': ['get', 'cultivar_name'],
        'text-variable-anchor': ['top', 'bottom', 'left', 'right'],
        'text-radial-offset': 1.5,
        'text-justify': 'auto',
      },
    });
  });
}

function addClickHandlers(map: Map) {
  map.on('click', 'custom-marker-layer', function (e) {
    if (!e.features || !e.features[0] || !e.features[0].properties) {
      return;
    }
    const cultivarId = e.features[0].properties.cultivar_id;
    routeToInfoPanel(cultivarId);
  });
}

export function generateMap() {
  const map = fetchMap();
  generateMarkers(map);
  addClickHandlers(map);
}
