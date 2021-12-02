module Capcoauth
  module OAuth
    class TTLCache

      def self.user_id_for(access_token)
        store.fetch(key_for(access_token))
      end

      def self.update(access_token, user_id)
        store.write(key_for(access_token), user_id, expires_in: Capcoauth.configuration.token_verify_ttl)
      end

      def self.remove(access_token)
        store.delete_matched(key_for(access_token))
      end

      def self.key_for(access_token)
        "capcoauth_token:#{access_token}"
      end

      def self.store
        Capcoauth.configuration.cache_store
      end
    end
  end
end
