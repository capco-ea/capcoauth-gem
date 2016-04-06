require 'capcoauth/rails/routes/mapping'
require 'capcoauth/rails/routes/mapper'

module CapcOAuth
  module Rails
    class Routes
      module Helper
        def use_capcoauth(options = {}, &block)
          CapcOAuth::Rails::Routes.new(self, &block).generate_routes!(options)
        end
      end

      def self.install!
        ActionDispatch::Routing::Mapper.send :include, CapcOAuth::Rails::Routes::Helper
      end

      attr_accessor :routes

      def initialize(routes, &block)
        @routes, @block = routes, block
      end

      def generate_routes!(options)
        @mapping = Mapper.new.map(&@block)
        routes.scope options[:scope] || 'auth', as: 'auth' do
          map_route(:login, :login_routes)
          map_route(:logout, :logout_routes)
          map_route(:callback, :callback_routes)
        end
      end

      private

      def map_route(name, method)
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
          only: [:show, :delete], as: mapping[:as],
          controller: mapping[:controllers]
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
