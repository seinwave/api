import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';
export default class extends Controller<Element> {
  connect() {
    document.addEventListener('DOMContentLoaded', () => {
      mapboxgl.accessToken = accessToken;

      const map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/light-v11',
        center: [-73.96527, 40.66911],
        zoom: 19,
        bearing: 14,
      });

      map.on('load', () => {
        fetch('/plants/show')
          .then((response) => {
            console.log(response);
            response.json();
          })
          .then((data) => {
            console.log({ data });
            const geoJsonFeatures = data.plants.map((plant) => ({
              type: 'Feature',
              geometry: {
                type: 'Point',
                coordinates: [plant.longitude, plant.latitude],
              },
              properties: {},
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
                'icon-size': [
                  'interpolate',
                  ['linear'],
                  ['zoom'],
                  0,
                  0.005,
                  22,
                  0.05,
                ],
                'icon-allow-overlap': false,
              },
            });
          })
          .catch((error) => console.error('Error fetching rose data:', error));
      });
    });
  }
}
