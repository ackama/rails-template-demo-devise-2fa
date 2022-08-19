module Users
  class SessionsController < Devise::SessionsController
    ##
    # We want to make sure that when a user logs out (i.e. destroys their
    # session) then the session cookie they had cannot be used again. We
    # achieve this by overriding the built-in devise implementation of
    # `Devise::SessionsController#destroy` action to invalidate all existing
    # user sessions and then call `super` to run the built-in devise
    # implementation of the method.
    #
    # References
    #   * https://github.com/plataformatec/devise/issues/3031
    #   * http://maverickblogging.com/logout-is-broken-by-default-ruby-on-rails-web-applications/
    #   * https://makandracards.com/makandra/53562-devise-invalidating-all-sessions-for-a-user
    #
    def destroy
      current_user.invalidate_all_sessions!
      super
    end

    # This is direclty from https://github.com/heartcombo/devise/blob/main/app/controllers/devise/sessions_controller.rb
    # POST /resource/sign_in
    # def create
    #   self.resource = warden.authenticate!(auth_options)
    #   set_flash_message!(:notice, :signed_in)
    #   sign_in(resource_name, resource)
    #   yield resource if block_given?
    #   respond_with resource, location: after_sign_in_path_for(resource)
    # end

    ##
    # Validate the username and password params but **do not sign in the user**.
    #
    def verify_first_factor_creds
      user = find_user_matching_first_factor_creds
      output = if user
                 {
                   firstFactorCredsVerified: true,
                   secondFactorRequired: user.otp_required_for_login
                 }
               else
                 {
                   firstFactorCredsVerified: false,
                   errorMsg: I18n.t("devise.failure.invalid", authentication_keys: "Email")
                 }
               end

      render json: output
    end

    private

    ##
    # Find the user and validat the password.
    #
    def find_user_matching_first_factor_creds
      user = User.find_for_authentication(email: email_param)
      user&.valid_password?(password_param) ? user : nil
    end

    def email_param
      params.require(:user).fetch(:first_factor_email)
    end

    def password_param
      params.require(:user).fetch(:first_factor_password)
    end
  end
end
