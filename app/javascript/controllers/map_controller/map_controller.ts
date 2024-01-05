import { Controller } from '@hotwired/stimulus';
import { fetchPlants, routeToInfoPanel } from '../api';
import mapboxgl from 'mapbox-gl';
import type { Map, LngLatBoundsLike } from 'mapbox-gl';

export default class MapController extends Controller<Element> {
  static targets = ['mapContainer', 'favorite-link', 'singleResult'];
  static values = { url: String };
  declare highlightedFeature: any;
  declare _mapValue: Map;
  declare mapReadyPromise: Promise<void>;
  mapReadyResolve: () => void;

  initialize() {
    this.mapReadyPromise = new Promise((resolve) => {
      this.mapReadyResolve = resolve;
    });

    this.fetchMap();
  }

  set mapValue(value) {
    this.mapReadyResolve();
    this._mapValue = value;
  }

  get mapValue() {
    return this._mapValue;
  }

  connect() {
    this.highlightedFeature = null;
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

    this.mapValue = map;
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
      this.highlightIndividualFeature(e.features[0]);
    });
  }

  async extractFeatureFromPlant(plant) {
    const map = this.mapValue;

    return new Promise((resolve) => {
      map.on('idle', () => {
        try {
          const matchingFeature = map.querySourceFeatures('plants-source', {
            filter: ['==', ['get', 'id'], plant.id],
          })[0];

          console.log(map.querySourceFeatures('plants-source'));

          resolve(matchingFeature[0]);
        } catch (e) {
          console.log(e);
        }
      });
    });
  }

  async extractFeatureFromEvent(event) {
    let plant;
    // came from a click event
    if (event.params && event.params.plant) {
      plant = event.params.plant;
    }
    // came from a show_with_query or show_with_id event
    else if (event.dataset.mapInitialCultivarParam) {
      plant = JSON.parse(event.dataset.mapInitialCultivarParam);
    }

    return await this.extractFeatureFromPlant(plant);
  }

  singleResultTargetConnected(event) {
    this.mapReadyPromise.then(() => {
      this.mapValue.on('load', () => {
        this.processEvent(event);
      });
    });
  }

  async processEvent(event) {
    const feature = await this.extractFeatureFromEvent(event);
    this.flyToFeature(feature);
    this.highlightIndividualFeature(feature);
  }

  panToFeature(feature) {
    const map = this.mapValue;
    const lng = feature.geometry.coordinates[0];
    const lat = feature.geometry.coordinates[1];
    map.panTo([lng, lat]);
  }

  handleClickedFeature(event) {
    this.mapReadyPromise.then(() => {
      this.mapValue.on('load', () => {
        const feature = this.extractFeatureFromEvent(event);
        this.panToFeature(feature);
        this.highlightIndividualFeature(feature);
      });
    });
  }

  handleClickedMapButton(event) {
    const feature = this.extractFeatureFromEvent(event);
    this.panToFeature(feature);
    this.highlightIndividualFeature(feature);
  }

  flyToFeature(feature) {
    console.log('flying to feature:', { feature });

    const map = this.mapValue;
    const lng = feature.geometry.coordinates[0];
    const lat = feature.geometry.coordinates[1];
    map.flyTo({ center: [lng, lat], zoom: 25, speed: 1 });
  }

  highlightIndividualFeature(feature) {
    const map = this.mapValue;
    this.highlightedFeature = feature;
    map.setFeatureState(
      { source: 'plants-source', id: feature.id },
      { highlight: true }
    );
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

    if (!this.highlightedFeature) {
      return;
    }

    map.setFeatureState(
      { source: 'plants-source', id: this.highlightedFeature.id },
      { highlight: false }
    );

    this.highlightedFeature = null;
  }
}
