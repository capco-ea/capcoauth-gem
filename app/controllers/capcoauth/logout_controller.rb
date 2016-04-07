module Capcoauth
  class LogoutController < Capcoauth::ApplicationController

    def show
      session.delete(:capcoauth_user_id)
      if session.delete(:capcoauth_access_token)
        redirect_to root_url, notice: 'You have been logged out'
      else
        redirect_to root_url
      end
    end
  end
end
