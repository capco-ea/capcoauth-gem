class Capcoauth::InstallGenerator < ::Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)
  desc 'Installs Capcoauth'

  def install
    template 'initializer.rb', 'config/initializers/capcoauth.rb'
    route 'use_capcoauth'
    readme 'README'
  end
end
