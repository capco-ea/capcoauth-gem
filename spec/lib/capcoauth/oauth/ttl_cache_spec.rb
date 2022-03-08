require 'spec_helper_integration'

describe Capcoauth::OAuth::TTLCache do
  subject { Capcoauth::OAuth::TTLCache }

  describe '#user_id_for' do
    it 'returns nil when store contains no token' do
      expect(subject.user_id_for('idontexist')).to be_nil
    end

    it 'returns user_id when store contains token' do
      subject.update('abc', '123')
      expect(subject.user_id_for('abc')).to eq('123')
      subject.remove('abc')
    end

    it 'returns user_id when TTL is almost expired' do
      subject.update('abc', '123')
      Timecop.freeze(Time.zone.now + (Capcoauth.configuration.token_verify_ttl - 1).seconds) do
        expect(subject.user_id_for('abc')).to eq('123')
      end
      subject.remove('abc')
    end

    it 'returns nil when TTL is expired' do
      subject.update('abc', '123')
      Timecop.freeze(Time.zone.now + (Capcoauth.configuration.token_verify_ttl + 1).seconds) do
        expect(subject.user_id_for('abc')).to be_nil
      end
      subject.remove('abc')
    end
  end

  describe '#update' do
    it 'returns true on write' do
      expect(subject.update('abc', '123')).to be true
      expect(subject.user_id_for('abc')).to eq('123')
      subject.remove('abc')
    end

    it 'respects expires_in TTL' do
      subject.update('abc', '123')
      Timecop.freeze(Time.zone.now + (Capcoauth.configuration.token_verify_ttl - 1).seconds) do
        expect(subject.user_id_for('abc')).to eq('123')
      end
      Timecop.freeze(Time.zone.now + (Capcoauth.configuration.token_verify_ttl + 1).seconds) do
        expect(subject.user_id_for('abc')).to be_nil
      end
      subject.remove('abc')
    end

    it 'overwrites existing values' do
      subject.update('abc', '123')
      expect(subject.update('abc', '456')).to be true
      expect(subject.user_id_for('abc')).to eq('456')
      subject.remove('abc')
    end
  end

  describe '#remove' do
    it 'returns false when value doesn\'t exist' do
      expect(subject.remove('idontexist')).to be false
    end
    it 'returns true when value exists' do
      expect(subject.update('abc', '123')).to be true
      expect(subject.remove('abc')).to be true
    end
    it 'returns false when value is expired and false after removed' do
      expect(subject.update('abc', '123')).to be true
      Timecop.freeze(Time.zone.now + (Capcoauth.configuration.token_verify_ttl + 1).seconds) do
        expect(subject.remove('abc')).to be false
        expect(subject.remove('abc')).to be false
      end
    end
  end

  describe '#key_for' do
    it 'returns formatted key' do
      expect(subject.key_for('abc')).to eq('capcoauth_token:abc')
    end
  end

  describe '#store' do
    it 'returns Capcoauth.cache_store' do
      expect(subject.store).to equal(Capcoauth.configuration.cache_store)
    end
  end
end
