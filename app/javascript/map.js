document.addEventListener('DOMContentLoaded', () => {
  const accessToken = appConfig.mapbox_access_token;
  mapboxgl.accessToken = accessToken;

  console.log({ accessToken });

  const map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/light-v11',
    center: [-73.96527, 40.66911],
    zoom: 23,
  });
});
