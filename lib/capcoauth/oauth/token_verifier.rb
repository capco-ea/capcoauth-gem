require 'httparty'

module Capcoauth
  module OAuth
    class TokenVerifier

      class UnauthorizedError < StandardError; end
      class OtherError < StandardError; end
      class ServerUnavailableError < StandardError; end

      def self.verify(access_token)
        raise UnauthorizedError, 'Please log in to continue' if access_token.blank? or access_token.token.blank?
        return access_token if TTLCache.user_id_for(access_token.token)

        # Call OAuth Service
        begin
          response = ::HTTParty.get("#{Capcoauth.configuration.capcoauth_backend_url}/oauth/token/info", {
            timeout: 5,
            headers: {
              'Authorization': "Bearer #{access_token.token}",
              'X-Forwarded-Proto': Capcoauth.configuration.force_backend_https_requests ? 'https' : nil,
              'Host': Capcoauth.configuration.force_backend_host_header,
            }.compact
          })
        rescue SocketError, Net::OpenTimeout
          raise ServerUnavailableError, 'An error occurred while verifying your credentials (server not available)'
        end

        # Set the user_id from the token response
        if response.code == 200

          # Get the proper ID value field from the response
          access_token.user_id = response.parsed_response['resource_owner_id']

          # Verify token is for correct application/client
          if response.parsed_response.fetch('application', {}).fetch('uid', nil) === Capcoauth.configuration.client_id
            logger.info("CapcOAuth: The access token for user ##{access_token.user_id} was verified successfully") unless logger.nil?
            TTLCache.update(access_token.token, access_token.user_id)
            access_token
          else
            logger.info("CapcOAuth: The access token for user ##{access_token.user_id} was valid, but for a different OAuth client ID") unless logger.nil?
            raise UnauthorizedError, 'Your credentials are valid, but are not for use with this system'
          end
        elsif response.code == 401
          TTLCache.remove(access_token.token)
          logger.info("CapcOAuth: The access token was invalid, expired, or revoked") unless logger.nil?
          raise UnauthorizedError, 'Please log in to continue'
        else
          logger.info("CapcOAuth: Received unknown response") unless logger.nil?
          logger.info(JSON.pretty_generate(response)) unless logger.nil?
          raise OtherError, 'An error occurred while verifying your credentials (unknown response)'
        end
      end

      private

      def self.logger
        Capcoauth.configuration.logger
      end
    end
  end
end
