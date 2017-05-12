module Capcoauth
  class LogoutController < Capcoauth::ApplicationController
    def show
      session.delete(:capcoauth_user_id)
      token = session.delete(:capcoauth_access_token)
      OAuth::TTLCache.remove(token) if token.present?
      redirect_to root_url, notice: 'You have been logged out'
    end
  end
end
