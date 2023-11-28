import { Controller } from '@hotwired/stimulus';
import { Notyf } from 'notyf';

interface ModalController extends Controller {
  closeModal(): void;
}

// Connects to data-controller="toast"
export default class extends Controller {
  static values = {
    message: String,
    type: String,
  };
  static outlets = ['modal'];
  declare modalOutlets: Array<ModalController>;
  declare messageValue: string;
  declare typeValue: string;
  declare notyf: Notyf;

  connect() {
    if (document.documentElement.hasAttribute('data-turbo-preview')) {
      // catching turbo previews, which hit a cache
      return;
    }

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
