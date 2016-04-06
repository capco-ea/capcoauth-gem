module CapcOAuth
  module Rails
    class Routes
      class Mapping
        attr_accessor :controllers, :as, :skips

        def initialize
          @controllers = {
            login: 'capcoauth/login',
            logout: 'capcoauth/logout',
            callback: 'capcoauth/callback',
          }

          @as = {
            login: :login,
            logout: :logout,
            callback: :callback
          }

          @skips = []
        end

        def [](routes)
          {
            controllers: @controllers[routes],
            as: @as[routes]
          }
        end

        def skipped?(controller)
          @skips.include?(controller)
        end
      end
    end
  end
end
