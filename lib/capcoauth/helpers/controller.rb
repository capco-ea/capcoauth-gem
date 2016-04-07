module Capcoauth
  module Helpers
    module Controller
      extend ActiveSupport::Concern

      private

      def capcoauth_token
        @token ||= OAuth::AccessToken.new(session[:capcoauth_access_token]).verify
      end

      def oauth_callback_url
        "#{root_url}auth/callback"
      end
    end
  end
end
