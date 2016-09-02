require 'capcoauth/version'
require 'capcoauth/engine'
require 'capcoauth/config'
require 'capcoauth/notifications'

require 'capcoauth/oauth/access_token'
require 'capcoauth/oauth/token_verifier'
require 'capcoauth/oauth/ttl_cache'

require 'capcoauth/helpers/controller'

require 'capcoauth/rails/routes'
require 'capcoauth/rails/helpers'

module Capcoauth
  def self.configured?
    @config.present?
  end

  def self.installed?
    configured?
  end
end
