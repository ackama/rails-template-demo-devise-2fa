# Be sure to restart your server when you modify this file.

# Configure parameters to be filtered from the log file. Use this to limit dissemination of
# sensitive information. See the ActiveSupport::ParameterFilter documentation for supported
# notations and behaviors.
Rails.application.config.filter_parameters += %i[
  passw secret token _key crypt salt certificate otp ssn
]

# IMPORTANT: Whenever your views/JS submit an OTP code they must call the field
# `otp_attempt` - if it is called anything else, it will be leaked into the logs
Rails.application.config.filter_parameters += %i[otp_attempt]
