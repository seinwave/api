import { Controller } from '@hotwired/stimulus';

const FOCUSABLE_ELEMENTS = [
  'a[href]',
  'area[href]',
  'input:not([disabled]):not([type="hidden"]):not([aria-hidden])',
  'select:not([disabled]):not([aria-hidden])',
  'textarea:not([disabled]):not([aria-hidden])',
  'button:not([disabled]):not([aria-hidden])',
  'iframe',
  'object',
  'embed',
  '[contenteditable]',
  '[tabindex]:not([tabindex^="-"])',
];

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
    this.setFocusToFirstNode();
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
      if (event.key === 'Tab' && this.open) {
        this.retainFocus(event);
      }
    });
  }

  addModalBackgroundClickEvent() {
    const modalBackground = document.getElementById('modal-background');
    modalBackground?.addEventListener('click', () => {
      this.closeModal();
    });
  }

  /* TAB AND FOCUS MANAGEMENT */

  getFocusableNodes() {
    const modalDialog = document.querySelector('.modal-dialog');
    const nodes = modalDialog?.querySelectorAll(FOCUSABLE_ELEMENTS.join(', '));
    return Array.from(nodes || []);
  }

  setFocusToFirstNode() {
    const focusableNodes = this.getFocusableNodes();

    // no focusable nodes
    if (focusableNodes.length === 0) return;

    const nodesWhichAreNotCloseTargets = focusableNodes.filter((node) => {
      return !node.hasAttribute('closeTrigger');
    });

    if (nodesWhichAreNotCloseTargets.length > 0) {
      (nodesWhichAreNotCloseTargets[0] as HTMLElement).focus();
    } else {
      (focusableNodes[0] as HTMLElement).focus();
    }
  }

  retainFocus(event) {
    let focusableNodes = this.getFocusableNodes();

    // no focusable nodes
    if (focusableNodes.length === 0) return;

    const focusedItemIndex = 0;

    if (event.shiftKey && focusedItemIndex === 0) {
      (focusableNodes[focusableNodes.length - 1] as HTMLElement).focus();
      event.preventDefault();
    }

    if (
      !event.shiftKey &&
      focusableNodes.length > 0 &&
      focusedItemIndex === focusableNodes.length - 1
    ) {
      (focusableNodes[0] as HTMLElement).focus();
      event.preventDefault();
    }
  }
}
