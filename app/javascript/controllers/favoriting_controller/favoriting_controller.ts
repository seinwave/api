import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="favoriting"
export default class FavoritingController extends Controller {
  addFavorite(event: Event) {
    const target = event.target as HTMLElement;
    const cultivarId =
      target.dataset.cultivarId && parseInt(target.dataset.cultivarId);
    console.log({ cultivarId });
  }
}
