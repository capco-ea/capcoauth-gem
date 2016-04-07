require 'uri'

module Capcoauth
  class LoginController < Capcoauth::ApplicationController
    def show
      if capcoauth_token
        redirect_to session[:previous_url].blank? ? root_url : session.delete(:previous_url), notice: 'You are already logged in'
        return
      end

      redirect_to "https://capcoauth.capco.com/oauth/authorize?client_id=#{Capcoauth.configuration.client_id}&redirect_uri=#{URI.encode(oauth_callback_url)}&response_type=code"
    end
  end
end
