module Capcoauth
  module Rails
    module Helpers
      extend ActiveSupport::Concern

      def current_user

        # Don't return user for options requests
        return if request.method_symbol == :options

        # Bypass if already set/verified
        return @current_user if @_current_user_performed
        @_current_user_performed = true

        # Get the token object
        token, error = verify_token.first

        # Skip lookup if application credentials or token invalid
        return nil if token.blank? or error.present?

        # Resolve user ID using configuration resolver unless already found
        begin
          @current_user = Capcoauth.configuration.user_resolver.call(token.user_id) if token.user_id.present?
        rescue ActiveRecord::RecordNotFound => e
          Capcoauth.configuration.logger.info "[CapcOAuth] Error looking up user: #{e.message}"
        end

        @current_user
      end

      def verify_authorized!

        # Don't verify options requests
        return if request.method_symbol == :options

        # Run verification
        token, error, reason = verify_token

        # Re-raise exceptions with human-readable reason
        raise Capcoauth::AuthorizationError, reason if error == :unauthorized_error

        # Raise an error if token has an ID but the user wasn't found
        if Capcoauth.configuration.require_user and token.present? and token.user_id.present? and current_user.blank?
          Capcoauth.configuration.logger.info "[CapcOAuth] Error looking up user: Token returned ID ##{token.user_id} but resolver didn't return user"
          raise Capcoauth::AuthorizationError, 'Your credentials were valid, but you aren\'t currently active in this system'
        end
      end

      private

        def capcoauth_token_unverified
          @_capcoauth_token_unverified ||= OAuth::AccessToken.new(token_from_request)
        end

        def token_from_request
          token_from_param || token_from_session || token_from_headers
        end

        def token_from_param
          params[:access_token]
        end

        def token_from_session
          session[:capcoauth_access_token]
        end

        def token_from_headers
          header_parts = (request.headers['AUTHORIZATION'] || '').split(' ')
          (header_parts.length == 2 and header_parts[0].downcase == 'bearer') ? header_parts[1] : header_parts[0]
        end

        def verify_token
          @_verify_token_response ||= begin
            [capcoauth_token_unverified.verify, nil, nil]
          rescue OAuth::TokenVerifier::UnauthorizedError => e
            session.delete(:capcoauth_access_token)
            session.delete(:capcoauth_user_id)
            Capcoauth.configuration.logger.info "[CapcOAuth] Verification unauthorized: #{e.message}"
            [nil, :unauthorized_error, e.message]
          rescue OAuth::TokenVerifier::OtherError => e
            session.delete(:capcoauth_access_token)
            session.delete(:capcoauth_user_id)
            Capcoauth.configuration.logger.info "[CapcOAuth] Verification error: #{e.message}"
            [nil, :other_error, e.message]
          end
        end
    end
  end
end
