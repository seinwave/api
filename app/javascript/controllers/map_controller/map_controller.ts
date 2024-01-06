import { Controller } from '@hotwired/stimulus';
import { fetchPlants, routeToInfoPanel } from '../api';
import mapboxgl from 'mapbox-gl';
import type { Map, LngLatBoundsLike } from 'mapbox-gl';

export default class MapController extends Controller<Element> {
  static targets = [
    'mapContainer',
    'favorite-link',
    'singleResult',
    'showById',
  ];
  static values = { url: String };
  declare highlightedFeature: any;
  declare hoveredFeature: any;
  declare hoveredFeatureTextState: any;
  declare geoJsonData: any;
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

      this.geoJsonData = geoJsonFeatures;

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
            'match',
            ['feature-state', 'text-state'],
            'hovered',
            'hsla(203, 97%, 59%, 1)',
            'highlighted',
            'hsla(3, 97%, 59%, 1)',
            'default',
            'hsla(132, 20%, 25%, 1)',
            'hsla(132, 20%, 25%, 1)',
          ],
          'text-halo-blur': [
            'match',
            ['feature-state', 'text-state'],
            'hovered',
            25,
            'highlighted',
            25,
            'default',
            0,
            0,
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

      this.hoveredFeature = e.features[0];

      const state = map.getFeatureState({
        source: 'plants-source',
        id: e.features[0].id,
      });

      this.hoveredFeatureTextState = state['text-state'];

      const id = e.features[0].id;

      map.getCanvas().style.cursor = 'pointer';

      map.setFeatureState(
        { source: 'plants-source', id: id },
        { 'text-state': 'hovered' }
      );
    });

    map.on('mouseleave', 'custom-marker-layer', function () {
      map.getCanvas().style.cursor = '';

      const previousState = this.hoveredFeatureTextState;

      map.setFeatureState(
        { source: 'plants-source', id: this.hoveredFeature.id },
        { 'text-state': previousState }
      );

      this.hoveredFeature = null;
    });
  }

  addClickHandlers() {
    const map = this.mapValue;
    map.on('click', 'custom-marker-layer', (e) => {
      if (!e.features || !e.features[0] || !e.features[0].properties) {
        return;
      }
      this.panToFeature(e.features[0]);
      const cultivarId = e.features[0].properties.cultivar_id;
      routeToInfoPanel(cultivarId);
    });
  }

  /* CONNECTING TO INDIVIDUAL TARGETS */
  singleResultTargetConnected(event) {
    this.mapReadyPromise.then(() => {
      const plant = this.extractPlantFromEvent(event);
      this.flyToPlant(plant);
    });
  }

  showByIdTargetConnected(event) {
    this.mapReadyPromise.then(() => {
      const plant = this.extractPlantFromEvent(event);
      this.flyToPlant(plant);
    });
  }

  extractPlantFromEvent(event) {
    let plant;
    // came from a click event
    if (event.params && event.params.plant) {
      plant = event.params.plant;
    }
    // came from a show_with_query req
    else if (event.dataset.mapQueriedPlantParam) {
      plant = JSON.parse(event.dataset.mapQueriedPlantParam);
    }
    // came from a show_by_id req
    else if (event.dataset.mapShowByIdPlantParam) {
      plant = JSON.parse(event.dataset.mapShowByIdPlantParam);
    }

    return plant;
  }

  /* MAP MOVEMENT */
  panToPlant(plant) {
    const map = this.mapValue;
    const lng = plant.longitude;
    const lat = plant.latitude;
    map.panTo([lng, lat]);
  }

  flyToPlant(plant) {
    const map = this.mapValue;
    const lng = plant.longitude;
    const lat = plant.latitude;
    map.flyTo({ center: [lng, lat], zoom: 25, speed: 1 });
  }

  panToFeature(feature) {
    const map = this.mapValue;
    const lng = feature.geometry.coordinates[0];
    const lat = feature.geometry.coordinates[1];
    map.panTo([lng, lat]);
  }

  flyToFeature(feature) {
    const map = this.mapValue;
    const lng = feature.geometry.coordinates[0];
    const lat = feature.geometry.coordinates[1];
    map.flyTo({ center: [lng, lat], zoom: 25, speed: 1 });
  }

  handleClickedMapButton(event) {
    const plant = this.extractPlantFromEvent(event);
    this.flyToPlant(plant);
    this.highlightCultivar(plant);
  }

  /* HANDLING HIGHLIGHTS */

  highlightCultivar(plant) {
    const map = this.mapValue;
    const cultivarId = plant.cultivar_id;

    const matchingFeatures = map.querySourceFeatures('plants-source', {
      filter: ['==', 'cultivar_id', cultivarId],
    });

    matchingFeatures.map((feature) => {
      map.setFeatureState(
        { source: 'plants-source', id: feature.id },
        { 'text-state': 'highlighted' }
      );
    });
  }

  highlightIndividualFeature(feature) {
    const map = this.mapValue;
    this.highlightedFeature = feature;

    const id = feature.properties.id;
    map.setFeatureState(
      { source: 'plants-source', id: feature.id || id },
      { 'text-state': 'highlighted' }
    );
  }

  clearHighlights() {
    const map = this.mapValue;
  }

  /* HANDLING FAVORITES */
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
}
