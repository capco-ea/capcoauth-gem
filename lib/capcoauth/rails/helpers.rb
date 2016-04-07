module Capcoauth
  module Rails
    module Helpers
      extend ActiveSupport::Concern

      def verify_authorized!
        if capcoauth_token
          session.delete(:previous_url)
        else
          session.delete(:capcoauth_access_token)
          session.delete(:capcoauth_user_id)
          session[:previous_url] = request.url
          redirect_to :auth_login
        end
      end

      def current_user
        User.find session[:capcoauth_user_id] if session[:capcoauth_user_id]
      end

      private

      def capcoauth_token
        @_capcoauth_token ||= OAuth::AccessToken.new(session[:capcoauth_access_token]).verify
      end
    end
  end
end
