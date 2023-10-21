import mapboxgl from 'mapbox-gl';
import { fetchPlants } from './api';

const roseIcon = new Image();

export function generateMap() {
  const mapContainer = document.getElementById('map-container');
  const roseIconPath = mapContainer && mapContainer.dataset.roseIconPath;

  roseIcon.src = roseIconPath || '';
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

  map.on('load', async () => {
    map.addImage('rose-icon', roseIcon);

    const plantData = await fetchPlants();

    const geoJsonFeatures = plantData.map((plant) => ({
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [plant.longitude, plant.latitude],
      },
      properties: {
        id: plant.id,
        cultivar_id: plant.cultivar_id,
      },
    }));

    const geoJsonFeatureCollection = {
      type: 'FeatureCollection',
      features: geoJsonFeatures,
    };

    map.addSource('plants-source', {
      type: 'geojson',
      data: geoJsonFeatureCollection,
    });

    map.addLayer({
      id: 'custom-marker-layer',
      type: 'symbol',
      source: 'plants-source',
      layout: {
        'icon-image': 'rose-icon',
        'icon-size': ['interpolate', ['linear'], ['zoom'], 0, 0.005, 22, 0.05],
        'icon-allow-overlap': false,
      },
    });
  });

  map.on('click', (e) => {
    const bbox = [
      [e.point.x - 5, e.point.y - 5],
      [e.point.x + 5, e.point.y + 5],
    ];

    const features = map.queryRenderedFeatures(bbox, {
      layers: ['custom-marker-layer'],
    });

    if (features.length) {
      const coordinates = features[0].geometry.coordinates.slice();
      const cultivarId = features[0].properties.cultivar_id;

      console.log({ cultivarId });

      new mapboxgl.Popup()
        .setLngLat(coordinates)
        .setHTML('<h3>Rose</h3><p>Clicked on a rose icon!</p>')
        .addTo(map);
    }
  });
}
