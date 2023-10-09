require 'uri'

module Capcoauth
  class LoginController < Capcoauth::ApplicationController
    def show

      # If set in session
      if session[:capcoauth_access_token]

        # Attempt to verify
        begin
          capcoauth_token.verify
          if Capcoauth.configuration.perform_login_redirects
            redirect_to session.delete(:previous_url) || root_url, notice: 'You are already logged in'
          else
            redirect_to root_url, notice: 'You are already logged in'
          end
          return
        rescue; end
      end

      # Otherwise, redirect
      params = {
        client_id: Capcoauth.configuration.client_id,
        redirect_uri: oauth_callback_url,
        response_type: 'code',
      }
      redirect_to "#{Capcoauth.configuration.capcoauth_url}/oauth/authorize?#{params.to_param}", allow_other_host: true
    end
  end
end
