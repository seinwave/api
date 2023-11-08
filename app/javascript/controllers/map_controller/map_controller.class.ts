import { Controller } from '@hotwired/stimulus';
import { generateMap } from './map';

declare global {
  interface Event {
    detail: {
      fetchResponse: {
        location: string;
      };
    };
  }
}

declare global {
  interface Window {
    Turbo: any;
  }
}

export class MapController extends Controller<Element> {
  initialize() {
    generateMap();
  }
}
