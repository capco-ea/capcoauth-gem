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

  # Configure CapcOAuth service URL
  # config.capcoauth_url ENV['CAPCOAUTH_URL']

  # Configure the logger to use for OAuth events
  config.logger Rails.logger
end
