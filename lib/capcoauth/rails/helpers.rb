module Capcoauth
  module Rails
    module Helpers
      extend ActiveSupport::Concern

      def verify_authorized!
        return if request.method_symbol == :options
        capcoauth_token.verify

        # Browser client
        if handle_sessions?
          session.delete(:previous_url)
        end

        @capcoauth_user_id ||= capcoauth_token.user_id
      rescue OAuth::TokenVerifier::UnauthorizedError
        if handle_sessions?
          session[:previous_url] = request.url
          session.delete(:capcoauth_access_token)
          session.delete(:capcoauth_user_id)
        end
        handle_unauthorized
      rescue OAuth::TokenVerifier::OtherError
        if handle_sessions?
          session.delete(:capcoauth_access_token)
          session.delete(:capcoauth_user_id)
        end
        handle_internal_server_error
      end

      def current_user
        verify_authorized!

        # Resolve user ID using configuration resolver unless already found
        unless @current_user
          begin
            @current_user = Capcoauth.configuration.user_resolver.call(@capcoauth_user_id)
          rescue ActiveRecord::RecordNotFound => e
            Capcoauth.configuration.logger.warn "[CapcOAuth] Error looking up user - #{e.message}"
          end
        end

        @current_user
      end

      def capcoauth_token
        @_capcoauth_token ||= OAuth::AccessToken.new(token_from_request)
      end

      protected

        def handle_unauthorized
          if handle_sessions?
            redirect_to :auth_login
          else
            render plain: 'Unauthorized', status: :unauthorized
          end
        end

        def handle_internal_server_error
          render plain: 'Internal server error', status: :internal_server_error
        end

      private

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

        def handle_sessions?
          request.format.html? and Capcoauth.configuration.using_routes
        end
    end
  end
end
