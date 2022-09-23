import { Controller } from '@hotwired/stimulus';

// eslint-disable-next-line import/no-anonymous-default-export
export default class extends Controller {
  static targets = [
    'firstFactorForm',
    'firstFactorFormEmail',
    'firstFactorFormPassword',
    'firstFactorFormRememberMe',
    'secondFactorForm',
    'secondFactorFormEmail',
    'secondFactorFormPassword',
    'secondFactorFormRememberMe',
    'footerLinks'
  ];

  async submitFirstFactor() {
    const form = this.firstFactorFormTarget;
    const formData = new FormData(form);

    const response = await fetch(form.action, {
      method: form.method,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      },
      body: formData
    });

    let result = null;

    if (response.ok) {
      result = await response.json();
    } else {
      this._sendShowFlashEvent('Failed to contact server. Please try again');
    }

    if (!result.firstFactorCredsVerified) {
      this._sendShowFlashEvent(result.errorMsg);
      return;
    }

    this._copyFieldsFromPreAuthFormToAuthForm();

    if (result.secondFactorRequired) {
      this._hideFirstFactorForm();
      this._hideFooterLinks();
      this._showSecondFactorForm();
    } else {
      this._submitSecondFactorForm();
    }
  }

  _sendShowFlashEvent(msg) {
    this.dispatch('showFlash', {
      prefix: null,
      detail: { type: 'alert', message: msg }
    });
  }

  _hideFirstFactorForm() {
    this.firstFactorFormTarget.classList.add('d-none');
  }

  _hideFooterLinks() {
    this.footerLinksTarget.classList.add('d-none');
  }

  _showSecondFactorForm() {
    this.secondFactorFormTarget.classList.remove('d-none');
  }

  _submitSecondFactorForm() {
    this.secondFactorFormTarget.submit();
  }

  _copyFieldsFromPreAuthFormToAuthForm() {
    this.secondFactorFormEmailTarget.value = this.firstFactorFormEmailTarget.value;
    this.secondFactorFormPasswordTarget.value = this.firstFactorFormPasswordTarget.value;
    this.secondFactorFormRememberMeTarget.value = this.firstFactorFormRememberMeTarget.value;
  }
}
