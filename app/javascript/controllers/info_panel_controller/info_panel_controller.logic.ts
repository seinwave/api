import { Controller } from '@hotwired/stimulus';
import { addToggleListener } from '../utils';

export class InfoPanelController extends Controller<Element> {
  initialize() {
    addToggleListener('info-panel-toggle', 'info-panel', 'hidden');
  }
}
