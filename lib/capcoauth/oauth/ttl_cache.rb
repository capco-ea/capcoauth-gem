module Capcoauth
  module OAuth
    class TTLCache

      class << self
        def user_id_for(access_token)
          store.fetch(key_for(access_token))
        end

        def update(access_token, user_id)
          store.write(key_for(access_token), user_id, expires_in: Capcoauth.configuration.token_verify_ttl)
        end

        def remove(access_token)
          id = user_id_for(access_token)
          store.delete_matched(key_for(access_token))
          !id.nil?
        end

        def key_for(access_token)
          "capcoauth_token:#{access_token}"
        end

        def store
          Capcoauth.configuration.cache_store
        end
      end
    end
  end
end
