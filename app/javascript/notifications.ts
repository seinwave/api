import { Notyf } from 'notyf';

declare global {
  interface Window {
    globalNotyf: Notyf;
  }
}

function deletePreviousNotyf() {
  const previousNotyf = document.querySelectorAll('notyf');
  if (previousNotyf) {
    previousNotyf.forEach((element) => {
      element.remove();
    });
  }
}

deletePreviousNotyf();

if (!window.globalNotyf) {
  window.globalNotyf = new Notyf({ duration: 5000, dismissible: true });
}
