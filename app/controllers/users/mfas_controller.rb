##
# Conceptually each user has one mfa resource which they can manage because
# devise-two-factor only supports one MFA code per user
#
# TODO: naming of this controller could be better
# TODO: what language should we use in UI, MFA is very jargon but everything else is too?
#
module Users
  class MfasController < ApplicationController
    # TODO: authorization here needs to check that you are operating only on yourself.
    # TODO: Could be extended to you being an admin by the app?

    # Add the environment name to the 2FA (Two Factor Auth) string so that
    # you can more easily tell the 2FA codes for different environments
    # apart in your 2FA app
    ISSUER = if Rails.env.production?
               "Demo".freeze
             else
               "Demo #{Rails.env}".freeze
             end
    ##
    # #show is the entry point for a user managing their MFA. It displays a
    # summary of the current state of their MFA setup and buttons/links to take
    # actions on it.
    #
    def show
    end

    ##
    # #new starts the process of setting up MFA for the user
    #
    def new
      if current_user.otp_enabled_and_required?
        redirect_to users_mfa_path,
                    notice: "You have already set up two-factor authentication (2FA). If you wish to change it you must delete it first"
        return
      end

      current_user.enable_otp!
    end

    ##
    # #create accepts the form submission from #new and checks that the TOTP
    # code supplied by the user is valid. If the user gives us a valid TOTP code
    # then we can we be confident they have correctly setup OTP so we can
    # require it at next sign in.
    def create
      if otp_param == current_user.current_otp
        current_user.require_otp!
        redirect_to users_mfa_path,
                    notice: "Success! A two-factor authentication code (TOTP code) will be required for all future sign ins"
      else
        flash.now[:alert] = "That was not a valid code. Please try again"
        render :new
      end
    end

    def reset_backup_codes
      @backup_codes = current_user.generate_otp_backup_codes!
      current_user.save!
      # TODO:
      # Turbo doesn't like that we render from a form submission
      # if I redirect I need to pass the backup codes which will not be available again
      # this seems bit pointless just to keep turbo happy
      # can I get a more elegant solution here?
    end

    def delete_backup_codes
      current_user.update!(otp_backup_codes: nil)
      redirect_to users_mfa_path, notice: "Backup codes successfully deleted"
    end

    ##
    # We want to support apps **requring** MFA. So we need to support users
    # changing their MFA device without disabling MFA on their account. If MFA
    # were optional, it would be enough for the user to first delete their MFA
    # and then create a new one.
    #
    def edit
      # same as the #destory -> #new flow except we never actually unset the "otp required at login" flag
      # just clicking on this link is destructive - do we need to warn them better?
      current_user.reset_otp_secret!
      flash.now[:info] = "Your OTP secret has been reset. You must now create a new one"
    end

    # submitted to from #edit
    def update
      # it is important that this action never disable MFA while it is changing the secret vaules
      if otp_param == current_user.current_otp
        current_user.require_otp!
        redirect_to users_mfa_path,
                    notice: "Success! A two-factor authentication code (TOTP code) will be required for all future sign ins"
        nil
      else
        flash.now[:alert] = "That was not a valid code. Please try again or contact support"
        render :edit
      end
    end

    ##
    # Remove MFA as a login requirement for the current user
    #
    # TEAM_DECISION_REQUIRED:
    #   You may want to remove this entirely if MFA is a requirement for all
    #   users in your app.
    def destroy
      current_user.disable_otp!
      redirect_to users_mfa_path, notice: "Successfully disabled two-factor authentication for your account"
    end

    private

    def otp_param
      params.require(:otp_attempt).gsub(/\A[^\d+]\z/, "")
    end
  end
end
