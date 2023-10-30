import { Controller } from '@hotwired/stimulus';
import { generateMap } from './map';

export class MapController extends Controller<Element> {
  initialize() {
    generateMap();
  }
}
