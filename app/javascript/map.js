document.addEventListener('DOMContentLoaded', () => {
  const accessToken = appConfig.mapboxToken;
  mapboxgl.accessToken = accessToken;

  const map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/light-v11',
    center: [-73.96527, 40.66911],
    zoom: 19,
    bearing: 14,
  });
});
