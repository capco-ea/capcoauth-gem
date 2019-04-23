require 'httparty'

module Capcoauth
  class Notifications
    include HTTParty

    class << self

      def store
        Capcoauth.configuration.cache_store
      end

      def bearer_token
        return store.fetch('application_token') if store.fetch('application_token').present?

        res = self.post(
          "#{Capcoauth.configuration.capcoauth_url}/oauth/token",
          {
            body: {
              grant_type: 'client_credentials',
            },
            basic_auth: {
              username: Capcoauth.configuration.client_id,
              password: Capcoauth.configuration.client_secret
            }
          }
        )
        if res.ok? and res.parsed_response['access_token']
          store.write('application_token', res.parsed_response['access_token'], expires_in: res.parsed_response['expires_in'])
        end
        store.fetch('application_token')
      end

      def default_headers
        {
          :'Authorization' => "Bearer #{bearer_token}",
          :'Content-Type'=>'application/vnd.api+json'
        }
      end

      def add_device_token(user_id, device_token, device_type, environment = 'production')
        body = {
          data: {
            type: 'user_devices',
            attributes: {
              device_token: device_token,
              device_type: device_type,
            },
            relationships: {
              user: {
                data: {
                  type: 'users',
                  id: user_id
                }
              }
            }
          }
        }
        body[:data][:attributes][:environment] = environment if device_type == 'ios'
        res = self.post(
          "#{Capcoauth.configuration.capcoauth_url}/api/v1/user_devices",
          {
            body: body.to_json,
            headers: default_headers
          }
        )
        store.delete('application_token') if res.code == 401
        return true if res.created?
        return true if res.body.include? 'has already been registered'
        false
      end

      def remove_device_token(device_token)
        res = self.delete("#{Capcoauth.configuration.capcoauth_url}/api/v1/user_devices/#{device_token}", headers: default_headers)
        store.delete('application_token') if res.code == 401
        res.code == 204
      end

      def notify(user_id, alert=nil, badge=nil, data={})
        return false unless Capcoauth.configuration.send_notifications

        data = JSON.generate data
        res = self.post(
          "#{Capcoauth.configuration.capcoauth_url}/api/v1/user_notifications",
          {
            body: {
              data: {
                type: 'user_notifications',
                attributes: {
                  alert: alert,
                  badge: badge,
                  data: data
                },
                relationships: {
                  user: {
                    data: {
                      type: 'users',
                      id: user_id
                    }
                  }
                }
              }
            }.to_json,
            headers: default_headers
          }
        )
        store.delete('application_token') if res.code == 401
        return true if res.created?
        false
      end
    end
  end
end
