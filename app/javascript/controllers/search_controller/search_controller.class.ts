import { Controller } from '@hotwired/stimulus';
import { queryCultivars, routeToInfoPanel, routeToResultPanel } from '../api';

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

      if (result.length === 0) {
        return;
      }

      if (result.length === 1) {
        routeToInfoPanel(result[0].id);
        return;
      } else {
        routeToResultPanel(result);
      }
    });
  }
}
