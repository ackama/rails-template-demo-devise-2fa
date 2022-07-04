# Conceptually each user has one mfa resource which they can manage because devise-two-factor only supports one MFA code per user
# TODO: naming of this controller could be better
# TODO: what language should we use in UI, MFA is very jargon but everything else is too?
module Users
  class MfasController < ApplicationController
    # TODO: auth here needs to check that you are operating only on yourself. Could be extended to you being an admin by the app

    # no index method - this is a singular resource
    # def index

    # user sent here if they don't have mfa setup yet
    def new
    end

    # might need a second step in the new mfa flow
    def new_step_2
    end

    # the last step in the "setup" flow goes to here
    def create
    end

    # this is the starting point for users who have mfa setup
    def show
      # redirect to #new if mfa not setup yet

      # show details of existing mfa:
      # thta it is setup
      # show their backup codes
    end

    # We want to support apps **requring** MFA. So we need to support users
    # changing their MFA device without disabling MFA on their account. If MFA
    # were optional, it would be enough for the user to first delete their MFA
    # and then create a new one.
    def edit
      # linked to from #show
      # show the form allowing them to change their MFA
      # Q: it's unclear how much this would have in common with #new
    end

    # submitted to from #edit
    def update
      # it is important that this action never disable MFA while it is changing the secret vaules
    end

    # destroy their mfa setup (if this app allows that)
    # App dev may want to remove this entirely
    def destroy
      # disable mfa for this user
      # put notice in the flash

      redirect_to users_mfa_path
    end
  end
end
