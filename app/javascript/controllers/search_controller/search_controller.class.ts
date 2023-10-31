import { Controller } from '@hotwired/stimulus';
import { queryCultivars } from './api';

// Connects to data-controller="search"
export class SearchController extends Controller {
  initialize() {
    console.log('INITIALIZE SEARCH CONTROLLER');
    const searchForm = document.getElementById('search-form');
    const searchInput = document.getElementsByClassName(
      'search-input'
    )[0] as HTMLInputElement;

    searchForm?.addEventListener('submit', (event) => {
      event.preventDefault();
      const query = searchInput.value || '';
      queryCultivars(query);
    });
  }
}
