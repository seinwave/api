import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="search"
export class SearchController extends Controller {
  connect() {
    const searchInput = document.getElementById('search-input');
    searchInput?.addEventListener('keydown', async (event) => {
      console.log(event);
    });
  }
}
