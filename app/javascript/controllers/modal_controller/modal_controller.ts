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
  declare lastFocusedElement: HTMLElement;

  initialize() {
    this.open = false;
    this.addKeyboardEvents();
    this.addModalBackgroundClickEvent();
  }

  toggleModal() {
    this.open ? this.closeModal() : this.openModal();
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

  /* OPENING THE MODAL */
  openModal() {
    this.setLastFocusedElement();
    this.open = true;
    this.revealModalBackground();
    this.revealModalDialog();
    this.removeAriaHidden();
    this.addAriaModal();
    this.addDialogRole();
    this.disableClickThroughs();
    this.setFocusToFirstNode();
  }

  addAriaModal() {
    const modalDialog = document.getElementById('modal-dialog');
    modalDialog?.setAttribute('aria-modal', 'true');
  }

  addDialogRole() {
    const modalDialog = document.querySelector('.modal-dialog');
    modalDialog?.setAttribute('role', 'dialog');
  }

  removeAriaHidden() {
    const modal = document.querySelector('.modal');
    modal?.removeAttribute('aria-hidden');
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

  /* CLOSING THE MODAL */

  closeModal() {
    this.open = false;
    this.restoreLastFocusedElement();
    this.hideModalBackground();
    this.hideModalDialog();
    this.addAriaHidden();
    this.removeAriaModal();
    this.removeDialogRole();
    this.restoreClickThroughs();
  }

  removeAriaModal() {
    const modalDialog = document.querySelector('.modal-dialog');
    modalDialog?.removeAttribute('aria-modal');
  }

  addAriaHidden() {
    const modal = document.querySelector('.modal');
    modal?.setAttribute('aria-hidden', 'true');
  }

  removeDialogRole() {
    const modalDialog = document.querySelector('.modal-dialog');
    modalDialog?.removeAttribute('role');
  }

  hideModalBackground() {
    const modalBackground = document.getElementById('modal-background');
    modalBackground?.classList.remove('open');
  }

  hideModalDialog() {
    const modalDialog = document.querySelector('.modal-dialog');
    modalDialog?.classList.remove('open');
  }

  restoreClickThroughs() {
    const wrapper = document.querySelector('.wrapper');
    wrapper?.classList.remove('no-click-through');
  }

  /* TAB AND FOCUS MANAGEMENT */

  /* Restores focus to the last element that had focus before the modal opened.
   A WAI/ARIA requirement -- see http://www.w3.org/TR/wai-aria-practices/#dialog_modal 
  */
  getLastFocusedElement() {
    const focusedElementBeforeModalOpened = document.querySelector(
      ':focus'
    ) as HTMLElement;
    return focusedElementBeforeModalOpened;
  }

  setLastFocusedElement() {
    this.lastFocusedElement = this.getLastFocusedElement();
  }

  restoreLastFocusedElement() {
    if (!this.lastFocusedElement) return;
    this.lastFocusedElement.focus();
  }

  /* Captures focus within the dialog modal.
   A WAI/ARIA requirement -- see http://www.w3.org/TR/wai-aria-practices/#dialog_modal 
  */

  getFocusableNodesWithinModal() {
    const modalDialog = document.querySelector('.modal-dialog');
    const nodes = modalDialog?.querySelectorAll(FOCUSABLE_ELEMENTS.join(', '));
    return Array.from(nodes || []);
  }

  setFocusToFirstNode() {
    const focusableNodes = this.getFocusableNodesWithinModal();

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
    let focusableNodes = this.getFocusableNodesWithinModal();

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
