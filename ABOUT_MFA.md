# About this branch

This branch contains the changes we would like rails-template to make to an app if they user enabled "Devise + 2FA"

## MFA background

There are 3 main ways MFA can be used in an app:

1. Optional MFA: something that users can opt-in to to improve the security of their account
    * Users can disable MFA if they choose to
2. MFA required for **all** users
    * All users **must** setup MFA as part of registration flow
    * All users can **never** disable MFA
3. MFA required for some users e.g. all users with the `admin` role
    * Users can register without MFA
    * Users must set up MFA when they become part of the group which requires it e.g. they are given a new role
    * Sign in flow must check whether the user requires MFA and enforce it if required

This template implements _Optional MFA_ (option 1).

We choose this because it is the simplest and is a starting point for
implementing the other kinds of MFA integration. The other kinds of MFA
integration require more deep integration with your app and have a lot more
scope for being different between applications e.g. is MFA required for role,
maybe a whole different user model etc. We don't think we could do a good job of
the more complex kinds of integration from a template.

The goal of this template is to provide your team with an _"MFA starting
point"_, not necessarily a complete MFA feature that you don't have to modify in
any way. If your app needs _Optional MFA_ then the code here is very close to
being complete. If you need required MFA then you will need to do some work to
integrate it with your app.

## The underlying MFA gem

This code installs and configures the [devise-two-factor](https://github.com/tinfoil/devise-two-factor) gem. devise-two-factor is quite bare bones so this code adds endpoints to help users manage their MFA.

# TODO

* UX Challenges
  * I've been working on this from the tech stuff up to the UX stuff. It might benefit from somebody starting from UX (user-flows etc. and working down). We are somewhat constrained here by not wanting to rewrite big chunks of devise.
  *  We currently ask for the OTP code on the devise sign-in screen? Does it need to be a second screen after sign-in?
      * ++ current way easiest to implement, it's what the gem encourages
      * ?? is it even possible to do it any other way?
        * the devise action which gets the username and pass would need to stash them somewhere waiting for the OTP code
          * put them in the session? and then ask for the 2fa? putting creds in session like that feels bad for security
      * i think this would be a pretty big change to how devise sign-in works, maybe more than we want?
      * ?? maybe we could do it client side? but browser would need to get a signal about that user requiring MFA in a way that wouldn't allow an attacker to enumerate which users require MFA and which don't
  * The terminology around MFA is confusing and I don't think I'm currently doing a good job of explaining it in plain english in the UI copy. This is probably something we want designer input on.
  * I don't think I'm warning users properly that "Reset my MFA" destroys their existing OTP secret so they can't actually sign in if they don't complete the reset
* After we agree that this branch is good:
  * Should these changes be applied by a whole separate template repo or by the main rails-template repo?


# ============= Content for README ================

### About MFA

* We only support one MFA device per user (`devise-two-factor` does not support multiple devices). If you need multiple devices, you probably want to fork `devise-two-factor`.

### MFA Backup codes

* Users can create _OTP Backup codes_ which they can use instead of the OTP value to sign in.
* Each backup code can be used **only once**
* Backup codes do not depend on the current OTP secret. Resetting the OTP secret does not invalidate the backup codes!



