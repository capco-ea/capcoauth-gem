Capcoauth.configure do |config|

  # CapcOAuth Client ID
  config.client_id = 'client_id_123'

  # CapcOAuth Client Secret
  config.client_secret = 'client_secret_456'

  # Configures how often to check CapcOAuth for access token validity, in seconds.  If this value is too high,
  # application will continue to serve requests to users after the token is revoked
  # config.token_verify_ttl = 10

  # Configure a cache store to use to cache access token resolutions.
  # config.cache_store = ActiveSupport::Cache::MemoryStore.new

  # CapcOAuth service URL
  # config.capcoauth_url = ENV['CAPCOAUTH_URL']

  # Configure the logger to use for OAuth events
  config.logger = Rails.logger

  # Configure which ID to identify the user by.  Valid options are :capcoauth, :capco (4-letter), :psoft, :e_number, and :cit
  # config.user_id_field = :capcoauth

  # Block to resolve your user from the provided CapcOAuth ID.  If you're using different primary keys than any of the
  # existing services, you might consider looking up by an external ID, e.g. `User.find_by_psoft_id! capcoauth_user_id`
  config.user_resolver = -> capcoauth_user_id {
    User.find_by! id: capcoauth_user_id # optionally, include `, inactive: false`, `, admin: true`, etc.
  }

  # When an access token has a user_id, but the user is not found via the above resolver, should an
  # Capcoauth::AuthorizationException be raised?  Helpful when you're syncing the user database separately and the user
  # doesn't exist locally.  Application credentials (token without a user_id) will still be allowed regardless.
  # config.require_user = true

  # Use CapcOAuth URL from config
  # config.capcoauth_url = ENV['CAPCOAUTH_URL']

  # Don't redirect to last URL on login since we don't want to see API responses
  # config.perform_login_redirects = true
end
