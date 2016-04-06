require 'capcoauth/version'
require 'capcoauth/engine'
require 'capcoauth/config'

require 'capcoauth/rails/routes'
require 'capcoauth/rails/helpers'

module CapcOAuth
  def self.configured?
    @config.present?
  end

  def self.installed?
    configured?
  end
end
