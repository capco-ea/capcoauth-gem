require 'capcoauth/version'
require 'capcoauth/config'

module CapcOAuth
  def self.configured?
    @config.present?
  end

  def self.installed?
    configured?
  end
end
