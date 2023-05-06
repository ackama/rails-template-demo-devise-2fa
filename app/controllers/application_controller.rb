class ApplicationController < ActionController::Base
  # before_action :enforce_otp_required_for_login
  # before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :require_multi_factor_authentication!
  # protected

  def require_multi_factor_authentication!
    return unless user_signed_in?
    return if devise_controller?
    return if current_user.otp_required_for_login?

    redirect_to new_users_multi_factor_authentication_path, alert: "MFA required"
  end

  # # TODO: You can change the logic in this function to enforce 2fa by role etc.
  # def enforce_otp_required_for_login
  #   return if current_user.nil?
  #   return if current_user.otp_required_for_login?

  #   # TODO: this could maybe be locked down tighter to just some actions.
  #   # Alternively we have a controller+action dedicated to this screen rather
  #   # than re-using the generic 2fa management controller
  #   return if controller_name == "two_factor_auths"

  #   # users can still sign-out
  #   return if request.path == destroy_user_session_path

  #   # require 'pry'; binding.pry
  #   puts "X" * 80
  #   p request.path
  #   p controller_name
  #   puts "X" * 80
  #   # If current_user does not have the "OTP required for login" flag set then
  #   # we redirect them to a page where they can set that up. This is the only
  #   # authenticated page they can see until they set up their two-factor authentication (2FA). This custom
  #   # controller could have its own layout which would avoid a bunch of if-else
  #   # in views to hide buttons that a user cannot click when they are in this
  #   # "can't do anything until set up 2fa" state
  #   redirect_to users_two_factor_auth_path, notice: I18n.t("two_factor_auth.must_setup_otp")
  # end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  # end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboards_path
  end
end
