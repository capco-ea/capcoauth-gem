require 'active_support/cache'

module Capcoauth
  class MissingConfigurationError < StandardError
    def message
      # :nocov:
      'Capcoauth configuration is missing.  Please ensure you have an initializer in config/initializers/capcoauth.rb'
      # :nocov:
    end
  end
  class MissingRequiredOptionError < StandardError; end

  def self.configure(&block)
    @config = Config::Builder.new(&block).build
  end

  def self.configuration
    @config || (fail MissingConfigurationError.new)
  end

  class Config
    CAPCOAUTH_URL_DEFAULT = 'https://apps.capco.com'.freeze
    TOKEN_VERIFY_TTL_DEFAULT = 60.freeze

    class Builder
      def initialize(&block)
        @config = Config.new

        # Set defaults
        @config.logger = ::Rails.logger
        @config.using_routes = false
        @config.perform_login_redirects = true
        @config.token_verify_ttl = TOKEN_VERIFY_TTL_DEFAULT
        @config.capcoauth_url = CAPCOAUTH_URL_DEFAULT
        @config.capcoauth_backend_url = CAPCOAUTH_URL_DEFAULT
        @config.force_backend_host_header = nil
        @config.cache_store = ::ActiveSupport::Cache::MemoryStore.new
        @config.require_user = true
        @config.logout_method = :POST
        @config.force_backend_https_requests = false

        # Evaluate configuration block
        @config.instance_eval(&block)
      end

      def build
        @config
      end
    end

    attr_accessor :logger,
                  :using_routes,
                  :perform_login_redirects,
                  :token_verify_ttl,
                  :capcoauth_url,
                  :capcoauth_backend_url,
                  :force_backend_host_header,
                  :cache_store,
                  :user_resolver,
                  :require_user,
                  :logout_method,
                  :force_backend_https_requests

    def client_id
      @client_id || raise(MissingRequiredOptionError, 'Missing required option `client_id`')
    end
    def client_id= (val=nil)
      raise(MissingRequiredOptionError, '`client_id` cannot be set to nil') if val.nil?
      @client_id = val
    end
    def client_secret
      @client_secret || raise(MissingRequiredOptionError, 'Missing required option `client_secret`')
    end
    def client_secret= (val=nil)
      raise(MissingRequiredOptionError, '`client_secret` cannot be set to nil') if val.nil?
      @client_secret = val
    end
    def user_resolver
      @user_resolver || raise(MissingRequiredOptionError, 'Missing required option/lambda `user_resolver`')
    end
    def user_resolver= (val=nil)
      raise(MissingRequiredOptionError, '`user_resolver` cannot be set to nil') if val.nil?
      @user_resolver = val
    end
  end
end
