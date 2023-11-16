import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';
import type { Map } from 'mapbox-gl';

// Connects to data-controller="favoriting"
export class FavoritingController extends Controller {
  addFavorite(event: Event) {
    const target = event.target as HTMLElement;
    const cultivarId =
      target.dataset.cultivarId && parseInt(target.dataset.cultivarId);
    console.log({ cultivarId });
  }
}
