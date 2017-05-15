module Capcoauth
  module OAuth
    class AccessToken
      attr_accessor :token
      attr_accessor :user_id

      def initialize(token)
        @token = token
        @user_id = TTLCache.user_id_for(token)
      end

      def verify
        TokenVerifier.verify(self)
      end
    end
  end
end
