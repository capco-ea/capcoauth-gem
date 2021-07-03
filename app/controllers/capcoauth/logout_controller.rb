module Capcoauth
  class LogoutController < Capcoauth::ApplicationController
    def show
      token = session[:capcoauth_access_token]
      session.destroy
      OAuth::TTLCache.remove(token) if token.present?
      redirect_to "#{Capcoauth.configuration.capcoauth_url}/users/sign_out", notice: 'You have been logged out'
    end
  end
end
