module Capcoauth
  class LogoutController < Capcoauth::ApplicationController
    def show
      token = session[:capcoauth_access_token]
      session.destroy
      OAuth::TTLCache.remove(token) if token.present?
      redirect_url = URI.encode_www_form_component(root_url)
      redirect_to "#{Capcoauth.configuration.capcoauth_url}/users/sign_out?return_to=#{redirect_url}", notice: 'You have been logged out'
    end
  end
end
