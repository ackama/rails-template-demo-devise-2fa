# MFA

> **Note** This should be moved to the README in the final PR

There are ? ways MFA can be in an app

1. Optional MFA: something that users can opt-in to to improve their security
    * Users can disable MFA if they choose to
1. MFA required for all users
    * Users must setup MFA as part of registration
    * Users can never disable MFA
1. MFA required for some users e.g. all users with a given role
    * This means the "requires mfa" flag must be set on the user when they get the role
    * If a user tries to sign in with the "requires mfa" flag set and they don't have it set, what do we do?



Backup codes do not depend on the current OTP secret - they are basically a set of one time passwords
  Could this be useful elsewhere?


Q: can we ask for MFA on the devise sign-in screen? or does it need to be a second screen after sign-in?
  ++ easiest to implement, it's what the gem encourages
  ?? is it even possible to do it any other way?
  devise action which gets the username and pass would hve to put them in the sssion? and athen ask for the 2fa. seems bad
  i think this would be a pretty big change to how devise sign-in works, maybe more than we want?

Q: should we have backup codes in the templated feature?

Possible approach: this template implements the optional path because the "user must" path requires many more integration points in your app
you can adapt the optional approach to the "user must" approach

This feature should be as agnostic as possible to the underlying 2fa implementation

TODO

* implmenet backup codes https://github.com/tinfoil/devise-two-factor#backup-codes
* fix security hole
  > Because of this, you need to set sign_in_after_reset_password to false (either globally in your Devise initializer or via devise_for).
* set Devise.otp_allowed_drift  to sensible
