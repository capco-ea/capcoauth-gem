module CapcOAuth
  class MissingConfiguration < StandardError
    def initialize
      super 'Configuration for CapcOAuth is missing.  Please ensure you have an initializer in config/capcoauth.rb'
    end
  end

  def self.configure(&block)
    @config = Config::Builder.new(&block).build
  end

  def self.configuration
    @config || (fail MissingConfiguration.new)
  end

  class Config
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
    end
  end
end
