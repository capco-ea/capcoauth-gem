module Capcoauth
  module OAuth
    class AccessToken
      attr_accessor :token
      attr_accessor :user_id

      def initialize(token)
        @token = token
      end

      def verify
        nil unless @token
        TokenVerifier.verify(self)
      end
    end
  end
end
