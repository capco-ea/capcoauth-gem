module Capcoauth
  module Helpers
    module Controller
      extend ActiveSupport::Concern

      def capcoauth_token
        @capcoauth_token ||= OAuth::AccessToken.new(session[:capcoauth_access_token])
      end

      def oauth_callback_url
        "#{root_url}auth/callback"
      end
    end
  end
end
