module Capcoauth
  module Rails
    module Helpers
      extend ActiveSupport::Concern

      def verify_authorized!
        if capcoauth_token
          session.delete(:previous_url)
        else
          session[:previous_url] = request.url
          redirect_to :auth_login
        end
      end

      private

      def capcoauth_token
        @_capcoauth_token ||= OAuth::AccessToken.new(session[:capcoauth_access_token]).verify
      end
    end
  end
end
