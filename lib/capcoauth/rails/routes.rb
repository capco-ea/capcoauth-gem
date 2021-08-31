require 'capcoauth/rails/routes/mapping'
require 'capcoauth/rails/routes/mapper'

module Capcoauth
  module Rails
    class Routes
      module Helper
        def use_capcoauth(options = {}, &block)
          Capcoauth::Rails::Routes.new(self, &block).generate_routes!(options)
          Capcoauth.configuration.using_routes = true
        end
      end

      def self.install!
        ActionDispatch::Routing::Mapper.send :include, Capcoauth::Rails::Routes::Helper
      end

      attr_accessor :routes

      def initialize(routes, &block)
        @routes, @block = routes, block
      end

      def generate_routes!(options)
        @mapping = Mapper.new.map(&@block)
        routes.scope options[:scope] || 'auth', as: 'auth' do
          map_routes(:login, :login_routes)
          map_routes(:logout, :logout_routes)
          map_routes(:callback, :callback_routes)
        end
      end

      private

      def map_routes(name, method)
        unless @mapping.skipped?(name)
          send method, @mapping[name]
        end
      end

      def login_routes(mapping)
        routes.resource(
          :login,
          path: 'login',
          only: [:show], as: mapping[:as],
          controller: mapping[:controllers]
        )
      end

      def logout_routes(mapping)
        routes.resource(
          :logout,
          path: 'logout',
          only: [:create, :update, :show, :delete], as: mapping[:as],
          controller: mapping[:controllers],
        )
      end

      def callback_routes(mapping)
        routes.resource(
          :callback,
          path: 'callback',
          only: [:show], as: mapping[:as],
          controller: mapping[:controllers]
        )
      end
    end
  end
end
