document.addEventListener('DOMContentLoaded', () => {
  mapboxgl.accessToken = 'YOUR_MAPBOX_ACCESS_TOKEN';

  const map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v11',
    center: [40.66911, -73.96527],
    zoom: 9,
  });
});
