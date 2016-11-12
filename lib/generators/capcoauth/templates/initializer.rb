Capcoauth.configure do |config|

  raise 'CapcOAuth Client ID not found' if ENV['CAPCOAUTH_CLIENT_ID'].nil?
  raise 'CapcOAuth Client secret not found' if ENV['CAPCOAUTH_CLIENT_SECRET'].nil?

  # CapcOAuth Client ID
  config.client_id ENV['CAPCOAUTH_CLIENT_ID']

  # CapcOAuth Client Secret
  config.client_secret ENV['CAPCOAUTH_CLIENT_SECRET']

  # Configures how often to check CapcOAuth for access token validity, in seconds.  If this value is too high,
  # application will continue to serve requests to users even after the token is revoked
  # config.token_verify_ttl 10

  # Configure a cache store to use to cache access token resolutions.
  # config.cache_store ActiveSupport::Cache::MemoryStore.new

  # Configure CapcOAuth service URL
  # config.capcoauth_url ENV['CAPCOAUTH_URL']

  # Configure the logger to use for OAuth events
  config.logger Rails.logger

  # Configure which ID to identify the user by.  Valid options are :capcoauth, :capco (4-letter), :psoft, :e_number, and :cit
  # config.user_id_field :capcoauth

  # Block to resolve your user from the provided CapcOAuth ID.  If you're using different primary keys than any of the
  # existing services, you might consider looking up by an external ID, e.g. `User.find_by_psoft_id! capcoauth_user_id`
  config.user_resolver do |capcoauth_user_id|
    User.find capcoauth_user_id
  end
end
