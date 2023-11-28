import { Controller } from '@hotwired/stimulus';
import { Notyf } from 'notyf';

// Connects to data-controller="toast"
export default class extends Controller {
  static values = {
    message: String,
    type: String,
  };
  static outlets = ['modal'];
  declare modalOutlets: Array<Controller>;
  declare messageValue: string;
  declare typeValue: string;
  declare notyf: Notyf;

  connect() {
    if (document.documentElement.hasAttribute('data-turbo-preview')) {
      // catching turbo previews, which hit a cache
      return;
    }

    console.log(
      document.documentElement,
      document.documentElement.hasAttribute('data-turbo-preview')
    );

    this.addToast();
  }

  addToast() {
    const notyf = window.globalNotyf;

    if (this.typeValue === 'success') {
      this.closeModal();
    }
    notyf[this.typeValue](this.messageValue);
  }

  closeModal() {
    this.modalOutlets.forEach((element) => {
      element.closeModal();
    });
  }
}
