module Capcoauth
  module OAuth
    class TTLCache
      @@cache = {}

      def self.valid?(access_token)
        purge
        !!@@cache[access_token]
      end

      def self.update(access_token)
        @@cache[access_token] = Time.zone.now
      end

      def self.remove(access_token)
        @@cache.delete(access_token)
      end

      def self.purge
        @@cache.delete_if do |k, v|
          Time.zone.now > v + Capcoauth.configuration.token_verify_ttl
        end
      end
    end
  end
end
