import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="modal"
export default class extends Controller {
  declare open: boolean;

  initialize() {
    this.open = false;
    this.addKeyboardEvents();
    this.addModalBackgroundClickEvent();
  }

  openModal() {
    this.open = true;
    this.revealModalBackground();
    this.revealModalDialog();
    this.disableClickThroughs();
  }

  revealModalBackground() {
    const modalBackground = document.getElementById('modal-background');
    modalBackground?.classList.add('open');
  }

  revealModalDialog() {
    const modalDialog = document.querySelector('.modal-dialog');
    modalDialog?.classList.add('open');
  }

  disableClickThroughs() {
    const wrapper = document.querySelector('.wrapper');
    wrapper?.classList.add('no-click-through');
  }

  restoreClickThroughs() {
    const wrapper = document.querySelector('.wrapper');
    wrapper?.classList.remove('no-click-through');
  }

  closeModal() {
    this.open = false;
    this.hideModalBackground();
    this.hideModalDialog();
    this.restoreClickThroughs();
  }

  hideModalBackground() {
    const modalBackground = document.getElementById('modal-background');
    modalBackground?.classList.remove('open');
  }

  hideModalDialog() {
    const modalDialog = document.querySelector('.modal-dialog');
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

  addModalBackgroundClickEvent() {
    const modalBackground = document.getElementById('modal-background');
    modalBackground?.addEventListener('click', () => {
      this.closeModal();
    });
  }
}
