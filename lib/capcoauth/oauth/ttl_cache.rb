module Capcoauth
  module OAuth
    class TTLCache
      @@cache = {}

      def self.user_id_for(access_token)
        purge
        return @@cache[access_token][:user_id] if @@cache[access_token].present?
        nil
      end

      def self.update(access_token, user_id)
        @@cache[access_token] = { last_checked: Time.zone.now, user_id: user_id }
      end

      def self.remove(access_token)
        @@cache.delete(access_token)
      end

      def self.purge
        @@cache.delete_if do |k, v|
          Time.zone.now > v[:last_checked] + Capcoauth.configuration.token_verify_ttl
        end
      end
    end
  end
end
