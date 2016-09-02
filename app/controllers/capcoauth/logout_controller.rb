module Capcoauth
  class LogoutController < Capcoauth::ApplicationController
    def show
      session.delete(:capcoauth_user_id)
      token = session.delete(:capcoauth_access_token)
      if token
        OAuth::TTLCache.remove(token)
        redirect_to root_url, notice: 'You have been logged out'
      else
        redirect_to root_url
      end
    end
  end
end
