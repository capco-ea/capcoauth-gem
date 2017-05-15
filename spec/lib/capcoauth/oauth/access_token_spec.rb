require 'spec_helper_integration'

describe Capcoauth::OAuth::AccessToken do

  describe '.initialize' do
    it 'has token but no user ID' do
      token = Capcoauth::OAuth::AccessToken.new 'abc'
      expect(token.token).to eq('abc')
      expect(token.user_id).to be_nil
    end

    it 'calls TTLCache.user_id_for and sets user_id to return value' do
      ttl_cache_double = class_double('Capcoauth::OAuth::TTLCache').as_stubbed_const
      allow(ttl_cache_double).to receive(:user_id_for).and_return('123')
      token = Capcoauth::OAuth::AccessToken.new 'abc'
      expect(token.token).to eq('abc')
      expect(token.user_id).to eq('123')
    end
  end

  describe '.verify' do
    it 'calls TokenVerifier.verify with self' do
      verifier_double = class_double('Capcoauth::OAuth::TokenVerifier').as_stubbed_const
      allow(verifier_double).to receive(:verify).and_return('CALLED')

      token = Capcoauth::OAuth::AccessToken.new nil
      expect(token.token).to be_nil
      expect(token.verify).to eq('CALLED')
    end
  end
end
