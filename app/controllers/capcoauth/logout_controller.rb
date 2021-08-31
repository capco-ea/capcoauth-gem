module Capcoauth
  class LogoutController < Capcoauth::ApplicationController
    before_action :check_method, only: %i[create show update destroy]
    skip_before_action :verify_authenticity_token, only: %i[create update destroy]

    def do_logout
      token = session[:capcoauth_access_token]
      session.destroy
      if token.present?
        OAuth::TTLCache.remove(token)
        Thread.new { revoke_token(token) }
      end

      # If request JSON, just return the url in a JSON hash
      logout_url = "#{Capcoauth.configuration.capcoauth_url}/users/sign_out"
      if request.format.json?
        render json: { logout_url: logout_url }
      else
        redirect_to logout_url, notice: 'You have been logged out'
      end
    end

    alias_method :create, :do_logout
    alias_method :show, :do_logout
    alias_method :update, :do_logout
    alias_method :destroy, :do_logout

    private

    def check_method
      return if Capcoauth.configuration.logout_method.to_sym == request.method_symbol.upcase
      raise ActionController::RoutingError.new("No route matches [#{request.method}] \"#{request.path}\"")
    end

    def revoke_token(token)
      Capcoauth.configuration.logger.info("Dispatching token revoke request for token #{token[0...5]}...#{token[-5..-1]}")
      auth_value = Base64.encode64("#{Capcoauth.configuration.client_id}:#{Capcoauth.configuration.client_secret}").squish
      http = Net::HTTP.new('capcoauth.capco.com', 443)
      http.use_ssl = true
      req = Net::HTTP::Post.new('/oauth/revoke', {
        'Authorization' => "Basic #{auth_value}",
        'Content-Type' => 'application/json',
      })
      req.body = { token: token }.to_json
      res = http.request(req)
      Capcoauth.configuration.logger.info("Revoke request completed with status #{res.code}")
    end
  end
end
