import { Controller } from '@hotwired/stimulus';
import { queryCultivars, routeToInfoPanel } from '../api';

// Connects to data-controller="search"
export class SearchController extends Controller {
  initialize() {
    const searchForm = document.getElementById(
      'search-form'
    ) as HTMLFormElement;

    searchForm?.addEventListener('submit', async (event) => {
      event.preventDefault();

      const inputForm = (event.target as HTMLFormElement)
        .elements[0] as HTMLInputElement;
      const query = inputForm.value;

      const result = await queryCultivars(query);
      const cultivarId = result[0]?.id;

      routeToInfoPanel(cultivarId);
    });
  }
}
