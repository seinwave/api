import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="toasts"
export default class extends Controller {
  static values = {
    message: String,
    type: String,
  };
  declare messageValue: string;
  declare typeValue: string;

  connect() {
    console.log(this.messageValue);
    console.log(this.typeValue);
  }
}
