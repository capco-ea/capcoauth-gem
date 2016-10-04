module Capcoauth
  class MissingConfiguration < StandardError
    def initialize
      super 'Capcoauth configuration is missing.  Please ensure you have an initializer in config/initializers/capcoauth.rb'
    end
  end

  def self.configure(&block)
    @config = Config::Builder.new(&block).build
  end

  def self.configuration
    @config || (fail MissingConfiguration.new)
  end

  class Config
    attr_reader :client_id
    attr_reader :client_secret
    attr_reader :logger
    attr_accessor :using_routes

    class Builder
      def initialize(&block)
        @config = Config.new
        instance_eval(&block)
      end

      def build
        @config
      end

      def client_id(client_id)
        @config.instance_variable_set('@client_id', client_id)
      end

      def client_secret(client_secret)
        @config.instance_variable_set('@client_secret', client_secret)
      end

      def logger(logger)
        @config.instance_variable_set('@logger', logger)
      end
    end

    module Option
      def option(name, options = {})
        attribute = options[:as] || name

        Builder.instance_eval do
          define_method name do |*args, &block|
            value = block ? block : args.first

            @config.instance_variable_set(:"@#{attribute}", value)
          end
        end

        define_method attribute do |*args|
          if instance_variable_defined?(:"@#{attribute}")
            instance_variable_get(:"@#{attribute}")
          else
            options[:default]
          end
        end

        public attribute
      end

      def extended(base)
        base.send(:private, :option)
      end
    end

    extend Option

    option :token_verify_ttl, default: 10
    option :capcoauth_url, default: 'https://capcoauth.capco.com'
    option :user_id_field, default: :capcoauth
    option :user_resolver, default: (lambda do |capcoauth_user_id|
      Capcoauth.configuration.logger.warn('[CapcOAuth] User resolver is not configured. Please specify a block in configuration to resolve the proper user')
      nil
    end)
  end
end
