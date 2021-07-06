module Capcoauth
  class LogoutController < Capcoauth::ApplicationController
    def show
      token = session[:capcoauth_access_token]
      session.destroy
      if token.present?
        OAuth::TTLCache.remove(token)
        Thread.new { revoke_token(token) }
      end
      redirect_to "#{Capcoauth.configuration.capcoauth_url}/users/sign_out", notice: 'You have been logged out'
    end

    private

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
