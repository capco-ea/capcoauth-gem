require 'httparty'
require 'net/http'

class MockHttpResponse
  def initialize(**opts)
    opts.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end
  def code; @code; end
  def headers; @headers; end
  def parsed_response; @body; end
end

describe Capcoauth::OAuth::TokenVerifier do
  subject { Capcoauth::OAuth::TokenVerifier }
  describe '#verify' do
    before do
      Capcoauth.configuration.client_id = 'verifier_test_client_id'
    end

    it 'raises UnauthorizedError when no access token object passed' do
      expect{subject.verify(nil)}.to raise_error(Capcoauth::OAuth::TokenVerifier::UnauthorizedError, 'Please log in to continue')
    end

    it 'raises UnauthorizedError when access token object has no token material' do
      expect{subject.verify(Capcoauth::OAuth::AccessToken.new(nil))}.to raise_error(Capcoauth::OAuth::TokenVerifier::UnauthorizedError, 'Please log in to continue')
    end

    it 'returns access token object if access_token is valid' do
      Capcoauth::OAuth::TTLCache.update('abc', '123')
      token = Capcoauth::OAuth::AccessToken.new('abc')
      expect(subject.verify(token)).to equal(token)
      Capcoauth::OAuth::TTLCache.remove('abc')
    end

    it 'calls HTTParty.get and raises OtherError on Net::OpenTimeout' do
      httparty_double = class_double('HTTParty').as_stubbed_const
      expect(httparty_double).to receive(:get).and_raise(Net::OpenTimeout)
      token = Capcoauth::OAuth::AccessToken.new('iamnew')
      expect{subject.verify(token)}.to raise_error(Capcoauth::OAuth::TokenVerifier::ServerUnavailableError, 'An error occurred while verifying your credentials (server not available)')
    end

    it 'calls HTTParty.get and raises UnauthorizedError if ID type is not returned' do
      Capcoauth.configuration.user_id_field = :psoft
      httparty_double = class_double('HTTParty').as_stubbed_const
      expect(httparty_double).to receive(:get).and_return(MockHttpResponse.new(code: 200, body: {
        'resource_owner_id' => '123',
        'external_ids' => {}
      }))
      token = Capcoauth::OAuth::AccessToken.new('iamnew')
      expect{subject.verify(token)}.to raise_error(Capcoauth::OAuth::TokenVerifier::UnauthorizedError, 'The system cannot recognize you by that ID type')
      Capcoauth.configuration.user_id_field = :capcoauth
    end

    it 'calls HTTParty.get and raises UnauthorizedError if ID type is not returned' do
      httparty_double = class_double('HTTParty').as_stubbed_const
      expect(httparty_double).to receive(:get).and_return(MockHttpResponse.new(code: 200, body: {
        'resource_owner_id' => '123',
        'application' => {
          'uid' => 'not_client_id_123'
        }
      }))
      token = Capcoauth::OAuth::AccessToken.new('iamnew')
      expect{subject.verify(token)}.to raise_error(Capcoauth::OAuth::TokenVerifier::UnauthorizedError, 'Your credentials are valid, but are not for use with this system')
    end

    it 'calls HTTParty.get and raises UnauthorizedError if token is unknown' do
      httparty_double = class_double('HTTParty').as_stubbed_const
      expect(httparty_double).to receive(:get).and_return(MockHttpResponse.new(code: 401, body: {
        'error': 'invalid_request',
        'error_description': 'The request is missing a required parameter, includes an unsupported parameter value, or is otherwise malformed.'
      }))
      token = Capcoauth::OAuth::AccessToken.new('iamnew')
      expect{subject.verify(token)}.to raise_error(Capcoauth::OAuth::TokenVerifier::UnauthorizedError, 'Please log in to continue')
    end

    it 'calls HTTParty.get and raises UnauthorizedError if token is unknown' do
      httparty_double = class_double('HTTParty').as_stubbed_const
      expect(httparty_double).to receive(:get).and_return(MockHttpResponse.new(code: 12345, body: {
        'error': 'invalid_request',
        'error_description': 'The request is missing a required parameter, includes an unsupported parameter value, or is otherwise malformed.'
      }))
      token = Capcoauth::OAuth::AccessToken.new('iamnew')
      expect{subject.verify(token)}.to raise_error(Capcoauth::OAuth::TokenVerifier::OtherError, 'An error occurred while verifying your credentials (unknown response)')
    end

    it 'calls HTTParty.get and returns access token with capcoauth id type' do
      httparty_double = class_double('HTTParty').as_stubbed_const
      expect(httparty_double).to receive(:get).and_return(MockHttpResponse.new(code: 200, body: {
        'resource_owner_id' => 'capcoauth_123',
        'application' => {
          'uid' => 'verifier_test_client_id'
        }
      }))
      token = Capcoauth::OAuth::AccessToken.new('capcoauth_user_token')
      expect(subject.verify(token)).to equal(token)
      expect(token.user_id).to eq('capcoauth_123')
      Capcoauth::OAuth::TTLCache.remove('capcoauth_user_token')
    end

    it 'calls HTTParty.get and returns access token with psoft id type' do
      Capcoauth.configuration.user_id_field = :psoft
      httparty_double = class_double('HTTParty').as_stubbed_const
      expect(httparty_double).to receive(:get).and_return(MockHttpResponse.new(code: 200, body: {
        'resource_owner_id' => '123',
        'application' => {
          'uid' => 'verifier_test_client_id'
        },
        'external_ids' => {
          'psoft' => 'psoft_123'
        }
      }))
      token = Capcoauth::OAuth::AccessToken.new('psoft_user_token')
      expect(subject.verify(token)).to equal(token)
      expect(token.user_id).to eq('psoft_123')
      Capcoauth::OAuth::TTLCache.remove('psoft_user_token')
      Capcoauth.configuration.user_id_field = :capcoauth
    end
  end
end
