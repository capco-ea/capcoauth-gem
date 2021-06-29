require 'httparty'

module Capcoauth
  class CallbackController < Capcoauth::ApplicationController
    def show

      # Abort if code not found
      return redirect_to root_url, alert: 'Authorization was canceled' unless params[:code].present?

      response = ::HTTParty.post("#{Capcoauth.configuration.capcoauth_url}/oauth/token", {
        body: {
          client_id: Capcoauth.configuration.client_id,
          client_secret: Capcoauth.configuration.client_secret,
          code: params[:code],
          grant_type: 'authorization_code',
          redirect_uri: oauth_callback_url
        }
      })

      error_message = 'There was an error logging you in'

      if response.code == 200 and !response.parsed_response['access_token'].blank?
        @access_token = OAuth::AccessToken.new(response.parsed_response['access_token']).verify

        if @access_token
          rotate_session_id
          session[:capcoauth_access_token] = @access_token.token
          session[:capcoauth_user_id] = @access_token.user_id
          redirect_to session[:previous_url].blank? ? root_url : session.delete(:previous_url)
        else
          redirect_to root_url, alert: error_message
        end
      else
        redirect_to root_url, alert: error_message
      end
    end
  end
end
