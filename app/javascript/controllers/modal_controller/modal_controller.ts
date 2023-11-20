import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="modal"
export default class extends Controller {
  declare open: boolean;

  initialize() {
    this.open = false;
    this.addKeyboardEvents();
  }

  openModal() {
    this.open = true;
    this.revealModalBackground();
    this.revealModalDialog();
  }

  revealModalBackground() {
    const modalBackground = document.getElementById('modal-background');
    modalBackground?.classList.add('open');
  }

  revealModalDialog() {
    const modalDialog = this.element.querySelector('.modal-dialog');
    modalDialog?.classList.add('open');
  }

  closeModal() {
    this.open = false;
    this.hideModalBackground();
  }

  hideModalBackground() {
    const modalBackground = document.getElementById('modal-background');
    modalBackground?.classList.remove('open');
  }

  hideModalDialog() {
    const modalDialog = this.element.querySelector('.modal-dialog');
    modalDialog?.classList.remove('open');
  }

  toggleModal() {
    this.open ? this.closeModal() : this.openModal();
  }

  addToggleLink() {
    const toggleLink = document.getElementById(
      'toggle-link'
    ) as HTMLAnchorElement;

    toggleLink?.addEventListener('click', (event) => {
      event.preventDefault();
      this.toggleModal();
    });
  }

  addKeyboardEvents() {
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && this.open) {
        this.closeModal();
      }
    });
  }
}
