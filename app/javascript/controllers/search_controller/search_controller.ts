import { Controller } from '@hotwired/stimulus';
import { queryCultivars } from '../api';

// Connects to data-controller="search"
export default class SearchController extends Controller {
  initialize() {
    this.addSearchForm();
  }

  addSearchForm() {
    const searchForm = document.getElementById(
      'search-form'
    ) as HTMLFormElement;

    searchForm?.addEventListener('submit', async (event) => {
      event.preventDefault();

      const inputForm = (event.target as HTMLFormElement)
        .elements[0] as HTMLInputElement;
      const query = inputForm.value.toLowerCase();

      await queryCultivars(query);
    });
  }
}
