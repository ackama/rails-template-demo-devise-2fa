import { Controller } from '@hotwired/stimulus';

// eslint-disable-next-line import/no-anonymous-default-export
export default class extends Controller {
  static targets = [
    'firstFactorForm',
    'secondFactorForm',
    'secondFactorFormEmail',
    'secondFactorFormPassword',
    'secondFactorFormRememberMe'
  ];

  async submitFirstFactor() {
    const form = this.firstFactorFormTarget;
    const formData = new FormData(form);

    console.log(form.method, form.action);

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
      log('Failed due to HTTP response error', response);
    }

    console.log(result);

    if (result.credsOk) {
      if (result.twoFactorRequired) {
        console.log('showing 2fa form');
        this._copyFieldsFromPreAuthFormToAuthForm();
        this.firstFactorFormTarget.classList.add('d-none');
        this.secondFactorFormTarget.classList.remove('d-none');
      } else {
        console.log('submitting form right away');
      }
    } else {
      this.dispatch('showFlash', {
        prefix: null,
        detail: { type: 'alert', message: result.errorMsg }
      });
    }
  }

  _copyFieldsFromPreAuthFormToAuthForm() {
    console.log('copying fields');

    const form1 = this.firstFactorFormTarget;
    const form2 = this.secondFactorFormTarget;

    form2.user_email.value = form1.pre_auth_email.value;
    form2.user_password.value = form1.pre_auth_password.value;
    form2.user_remember_me.value = form1.pre_auth_remember_me.value;
  }
}
