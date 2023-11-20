import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="modal"
export default class extends Controller {
  declare open: boolean;

  initialize() {
    this.open = false;
  }

  openModal() {
    this.open = true;
    this.element.classList.add('open');
  }

  closeModal() {
    this.open = false;
    this.element.classList.remove('open');
  }
}
