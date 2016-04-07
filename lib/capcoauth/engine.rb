module Capcoauth
  class Engine < Rails::Engine
    initializer 'capcoauth.params.filter' do |app|
      parameters = %w'code access_token'
      app.config.filter_parameters << /^(#{Regexp.union parameters})$/
    end

    initializer 'capcoauth.routes' do
      Capcoauth::Rails::Routes.install!
    end

    initializer 'capcoauth.helpers' do
      ActiveSupport.on_load(:action_controller) do
        include Capcoauth::Rails::Helpers
      end
    end
  end
end
