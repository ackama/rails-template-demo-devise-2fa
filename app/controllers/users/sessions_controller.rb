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

    # possible renames
    # first_factor_check
    # pre_auth_creds_check
    # preflight_creds_check
    # initial_creds_check
    def check_2fa_requirement
      # validate the creds we got but don't sign in the user
      # find out whether user requires 2fa sign-in or not and return it
      # if the user doesn't authenticate then we don't continue - they should get the same error as before - can i redirect to the normal url and have the form submit there?
      # require 'pry'; binding.pry
      # res = warden.authenticate!(auth_options) # this seems to redirect away to the error app

      puts "X" * 80
      p params
      puts "X" * 80
      # render json: {
      #   credsOk: false,
      #   errorMsg: "flash content goes here"
      # }
      render json: {
        credsOk: true,
        errorMsg: nil
      }
    end
  end
end
