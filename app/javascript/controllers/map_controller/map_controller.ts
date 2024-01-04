import { Controller } from '@hotwired/stimulus';
import { fetchPlants, routeToInfoPanel } from '../api';
import mapboxgl from 'mapbox-gl';
import type { Map, LngLatBoundsLike } from 'mapbox-gl';

export default class MapController extends Controller<Element> {
  static targets = ['mapContainer', 'favorite-link'];
  static values = { url: String };
  declare highlightFeature: any;
  declare mapValue: Map;

  connect() {
    const map = this.fetchMap();
    this.mapValue = map;
    this.highlightFeature = null;
    this.generateMarkers();
    this.addClickHandlers();
    this.setMapBounds();
    this.setMapZoomLevels();
    this.addHoverHandlers();
  }

  fetchMap() {
    const accessToken =
      'pk.eyJ1IjoibXNlaWRob2x6IiwiYSI6ImNsbnRkcmU1bDAyZmsycW8wdm94dmlsazEifQ.73QWWjTn7i9A0xsesKLqeQ';
    mapboxgl.accessToken = accessToken;
    const map = new mapboxgl.Map({
      container: 'map-container',
      style: 'mapbox://styles/mapbox/light-v11',
      center: [-73.96518, 40.66911],
      zoom: 20.8,
      bearing: 14,
    });

    return map;
  }

  setMapBounds() {
    const map = this.mapValue;

    const bounds: LngLatBoundsLike = [
      [-73.966, 40.6682], // [west, south]
      [-73.964, 40.6696], // [east, north]
    ];

    map.setMaxBounds(bounds);
  }

  setMapZoomLevels() {
    const map = this.mapValue;

    map.setMinZoom(19.5);
    map.setMaxZoom(22);
  }

  generateIcons() {
    const mapContainer = document.getElementById('map-container');

    const roseIcon = new Image();
    const roseIconPath = mapContainer && mapContainer.dataset.roseIconPath;
    roseIcon.src = roseIconPath || '';

    const heartIcon = new Image();
    const heartIconPath = mapContainer && mapContainer.dataset.heartIconPath;
    heartIcon.src = heartIconPath || '';

    return { roseIcon, heartIcon };
  }

  generateMarkers() {
    const map = this.mapValue;
    const { roseIcon, heartIcon } = this.generateIcons();

    map.on('load', async () => {
      map.addImage('rose-icon', roseIcon);
      map.addImage('heart-icon', heartIcon);

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
          //todo: change icon based on rose's primary color
          icon: plant.is_favorite ? 'heart-icon' : 'rose-icon',
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
        generateId: true,
        data: featureCollection,
      });

      map.addLayer({
        id: 'custom-marker-layer',
        type: 'symbol',
        source: 'plants-source',
        layout: {
          'icon-image': ['get', 'icon'],
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
          'text-field': ['get', 'cultivar_name'],
          'text-variable-anchor': ['top', 'bottom', 'left', 'right'],
          'text-radial-offset': 1.5,
          'text-justify': 'auto',
        },
        paint: {
          'text-color': [
            'case',
            ['boolean', ['feature-state', 'highlight'], false],
            'hsla(203, 97%, 59%, 1)',
            'hsla(132, 20%, 25%, 1)',
          ],
        },
      });
    });
  }

  addHoverHandlers() {
    const map = this.mapValue;
    map.on('mouseenter', 'custom-marker-layer', function (e) {
      if (!e.features || !e.features[0] || !e.features[0].properties) {
        return;
      }

      this.highlightFeature = e.features[0];

      const id = e.features[0].id;

      map.getCanvas().style.cursor = 'pointer';

      map.setFeatureState(
        { source: 'plants-source', id: id },
        { highlight: true }
      );
    });

    map.on('mouseleave', 'custom-marker-layer', function () {
      map.getCanvas().style.cursor = '';

      map.setFeatureState(
        { source: 'plants-source', id: this.highlightFeature.id },
        { highlight: false }
      );

      this.highlightFeature = null;
    });
  }

  addClickHandlers() {
    const map = this.mapValue;
    map.on('click', 'custom-marker-layer', (e) => {
      if (!e.features || !e.features[0] || !e.features[0].properties) {
        return;
      }
      const cultivarId = e.features[0].properties.cultivar_id;
      routeToInfoPanel(cultivarId);
      this.panToFeature(e.features[0]);
    });
  }

  panToFeature(feature) {
    const map = this.mapValue;
    const lng = feature.geometry.coordinates[0];
    const lat = feature.geometry.coordinates[1];
    map.flyTo({ center: [lng, lat], zoom: 23, speed: 0.8 });
  }

  removeFavorite(event: any) {
    const cultivarId = event.params.id;
    if (!cultivarId) {
      return [];
    }
    const map = this.mapValue;
    // @ts-ignore
    const geoJsonData = map.getSource('plants-source')._data;

    geoJsonData.features.map((feature) => {
      if (feature.properties && feature.properties.cultivar_id === cultivarId) {
        feature.properties.icon = 'rose-icon';
        return feature;
      }
    });
    // @ts-ignore
    map.getSource('plants-source').setData(geoJsonData);
  }

  addFavorite(event: any) {
    const cultivarId = event.params.id;
    if (!cultivarId) {
      return [];
    }
    const map = this.mapValue;
    // @ts-ignore
    const geoJsonData = map.getSource('plants-source')._data;

    geoJsonData.features.map((feature) => {
      if (feature.properties && feature.properties.cultivar_id === cultivarId) {
        feature.properties.icon = 'heart-icon';
        return feature;
      }
    });
    // @ts-ignore
    map.getSource('plants-source').setData(geoJsonData);
  }

  clearHighlights() {
    const map = this.mapValue;

    if (!this.highlightFeature) {
      return;
    }

    map.setFeatureState(
      { source: 'plants-source', id: this.highlightFeature.id },
      { highlight: false }
    );

    this.highlightFeature = null;
  }

  highlightIndividualPlant(plant) {
    this.clearHighlights();

    const map = this.mapValue;

    const plantId = plant.id;

    const matchingFeature = map.querySourceFeatures('plants-source', {
      filter: ['==', ['get', 'id'], plantId],
    })[0];

    this.highlightFeature = matchingFeature;

    const featureId = matchingFeature.id;

    map.setFeatureState(
      { source: 'plants-source', id: featureId },
      { highlight: true }
    );
  }

  panToPlant(event: any) {
    event.preventDefault();

    const plant = event.params.plant;

    if (!plant) {
      return;
    }
    const map = this.mapValue;

    const lng = plant.longitude;
    const lat = plant.latitude;

    this.highlightIndividualPlant(plant);

    map.flyTo({ center: [lng, lat], zoom: 25, speed: 1 });
  }
}
