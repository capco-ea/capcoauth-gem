module Capcoauth
  class LogoutController < Capcoauth::ApplicationController
    def show
      token = session[:capcoauth_access_token]
      session.destroy
      OAuth::TTLCache.remove(token) if token.present?
      redirect_to root_url, notice: 'You have been logged out'
    end
  end
end
