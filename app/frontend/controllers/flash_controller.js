import { Controller } from '@hotwired/stimulus';

const createDomFromStr = function (str) {
  const tmp = document.implementation.createHTMLDocument('');

  tmp.body.innerHTML = str;

  return tmp.body.children[0];
};

// eslint-disable-next-line import/no-anonymous-default-export
export default class extends Controller {
  static targets = ['container'];

  showFlash(event) {
    let typeClass = '';

    switch (event.detail.type) {
      case 'alert':
        typeClass = 'danger';
        break;
      case 'notice':
        typeClass = 'success';
        break;
    }

    const newFlash = createDomFromStr(
      `
        <div role="alert" class="alert alert-${typeClass}">
          ${event.detail.message}
        </div>
      `
    );

    this.containerTarget.appendChild(newFlash);
  }
}
