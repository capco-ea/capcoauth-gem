module Capcoauth
  class ApplicationController < ActionController::Base

    if ::Rails.version.to_i < 4
      protect_from_forgery
    else
      protect_from_forgery with: :exception
    end

    def capcoauth_token
      @capcoauth_token ||= OAuth::AccessToken.new(session[:capcoauth_access_token])
    end

    def oauth_callback_url
      "#{root_url}auth/callback"
    end
  end
end
