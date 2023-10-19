import { Controller } from '@hotwired/stimulus';
import { generateMap } from './generateMap';

export class MapController extends Controller<Element> {
  initialize() {
    generateMap();
  }
}
