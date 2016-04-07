require 'httparty'

module Capcoauth
  module OAuth
    class TokenVerifier
      def self.verify(access_token)
        return nil if access_token.blank? or access_token.token.blank?
        return access_token if TTLCache.valid?(access_token.token)

        # Call Capcoauth
        response = HTTParty.get('https://capcoauth.capco.com/oauth/token/info', {
          headers: {
            'Authorization' => "Bearer #{access_token.token}"
          }
        })

        # Set the user_id from the token response
        if response.code == 200
          TTLCache.update(access_token.token)
          access_token.user_id = response.parsed_response['resource_owner_id']
          access_token
        else
          TTLCache.remove(access_token.token)
          nil
        end
      end
    end
  end
end
