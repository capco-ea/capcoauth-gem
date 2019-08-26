require 'spec_helper_integration'

class DummyLogger; end
class DummyStore; end
class DummyUser
  attr_reader :user_id
  def initialize(user_id)
    @user_id = user_id
  end
end

describe Capcoauth::Config do
  subject {
    Capcoauth.configure do |config|
      config.client_id = 'ci'
      config.client_secret = 'cs'
      config.user_resolver = -> user_id {
        DummyUser.new user_id
      }
    end
  }

  describe 'subject' do
    it 'is an instance of Capcoauth::Config' do
      expect(subject).to be_a(Capcoauth::Config)
    end
  end

  describe 'default config requires required options' do
    subject :default_config do
      Capcoauth::Config::Builder.new do; end.build
    end

    it 'fails when not client_id not set' do
      expect{default_config.client_id}.to raise_error(Capcoauth::MissingRequiredOptionError, 'Missing required option `client_id`')
    end
    it 'fails when not client_secret not set' do
      expect{default_config.client_secret}.to raise_error(Capcoauth::MissingRequiredOptionError, 'Missing required option `client_secret`')
    end
    it 'fails when not client_user_resolver not set' do
      expect{default_config.user_resolver}.to raise_error(Capcoauth::MissingRequiredOptionError, 'Missing required option/lambda `user_resolver`')
    end
  end

  describe 'client_id' do
    it 'has value of ci' do
      expect(subject.client_id).to eq('ci')
    end
    it 'can be updated to test_123' do
      subject.client_id = 'test_123'
      expect(subject.client_id).to eq('test_123')
      subject.client_id = 'ci'
    end
    it 'cannot be set to nil' do
      expect{subject.client_id = nil}.to raise_error(Capcoauth::MissingRequiredOptionError, '`client_id` cannot be set to nil')
    end
  end

  describe 'client_secret' do
    it 'has value of cs' do
      expect(subject.client_secret).to eq('cs')
    end
    it 'can be updated to test_123' do
      subject.client_secret = 'test_456'
      expect(subject.client_secret).to eq('test_456')
      subject.client_secret = 'cs'
    end
    it 'cannot be set to nil' do
      expect{subject.client_secret = nil}.to raise_error(Capcoauth::MissingRequiredOptionError, '`client_secret` cannot be set to nil')
    end
  end

  describe 'user_resolver' do
    before do
      @old_resolver = subject.user_resolver
    end
    after do
      subject.user_resolver = @old_resolver
    end

    it 'sets the block that is accessible via user_resolver' do
      block = proc {}
      subject.user_resolver = block
      expect(subject.user_resolver).to equal(block)
    end

    it 'returns a dummy user' do
      returned_user = subject.user_resolver.call('123')
      expect(returned_user).to be_a(DummyUser)
      expect(returned_user.user_id).to eq('123')
    end

    it 'raises error from resolver' do
      subject.user_resolver = -> user_id {
        User.find_by! id: user_id
      }
      expect{subject.user_resolver.call('iwillneverexist')}.to raise_error(ActiveRecord::RecordNotFound, 'Couldn\'t find User')
    end
  end

  describe 'logger' do
    after do
      subject.logger = ::Rails.logger
    end

    it 'defaults to Rails.logger' do
      expect(subject.logger).to equal(::Rails.logger)
    end
    it 'can be updated to custom logger' do
      new_logger = DummyLogger.new
      subject.logger = new_logger
      expect(subject.logger).to equal(new_logger)
    end
    it 'can be set to nil' do
      subject.logger = nil
      expect(subject.logger).to be_nil
    end
  end

  describe 'using_routes' do
    it 'has value false by default' do
      expect(subject.using_routes).to eq(false)
    end
    it 'can be updated to true' do
      subject.using_routes = true
      expect(subject.using_routes).to eq(true)
      subject.using_routes = false
    end
    it 'is updated to true by Rails.application.routes.draw' do
      subject.using_routes = false
      expect(subject.using_routes).to be_falsy
      Rails.application.routes.draw do
        use_capcoauth
      end
      expect(subject.using_routes).to eq(true)
    end
  end

  describe 'perform_login_redirects' do
    it 'has value true by default' do
      expect(subject.perform_login_redirects).to eq(true)
    end
    it 'can be updated to false' do
      subject.perform_login_redirects = false
      expect(subject.perform_login_redirects).to eq(false)
      subject.perform_login_redirects = true
    end
  end

  describe 'token_verify_ttl' do
    it 'has value 10 by default' do
      expect(subject.token_verify_ttl).to eq(Capcoauth::Config::TOKEN_VERIFY_TTL_DEFAULT)
    end
    it 'can be updated to other value' do
      subject.token_verify_ttl = 60
      expect(subject.token_verify_ttl).to eq(60)
      subject.token_verify_ttl = Capcoauth::Config::TOKEN_VERIFY_TTL_DEFAULT
    end
  end

  describe 'capcoauth_url' do
    it "has value #{Capcoauth::Config::CAPCOAUTH_URL_DEFAULT} by default" do
      expect(subject.capcoauth_url).to eq(Capcoauth::Config::CAPCOAUTH_URL_DEFAULT)
    end
    it 'can be updated to other value' do
      subject.capcoauth_url = 'https://example.com'
      expect(subject.capcoauth_url).to eq('https://example.com')
      subject.capcoauth_url = Capcoauth::Config::CAPCOAUTH_URL_DEFAULT
    end
  end

  describe 'user_id_field' do
    it 'has value :capcoauth by default' do
      expect(subject.user_id_field).to eq(:capcoauth)
    end
    it 'can be updated to false' do
      subject.user_id_field = :psoft
      expect(subject.user_id_field).to eq(:psoft)
      subject.user_id_field = :capcoauth
    end
  end

  describe 'cache_store' do
    before do
      @cache_store = subject.cache_store
    end
    after do
      subject.cache_store = @cache_store
    end

    it 'defaults to ActiveSupport::Cache::MemoryStore store' do
      expect(subject.cache_store).to be_a(::ActiveSupport::Cache::MemoryStore)
    end
    it 'can be updated to custom store' do
      new_store = DummyStore.new
      subject.cache_store = new_store
      expect(subject.cache_store).to equal(new_store)
    end
    it 'can be set to nil' do
      subject.cache_store = nil
      expect(subject.cache_store).to be_nil
    end
  end

  describe 'require_user' do
    it 'has value false by default' do
      expect(subject.require_user).to eq(true)
    end
    it 'can be updated to false' do
      subject.require_user = false
      expect(subject.require_user).to eq(false)
      subject.require_user = true
    end
  end

  describe 'send_notifications' do
    it 'has value false by default' do
      expect(subject.send_notifications).to eq(false)
    end
    it 'can be updated to true' do
      subject.send_notifications = true
      expect(subject.send_notifications).to eq(true)
      subject.send_notifications = false
      expect(subject.send_notifications).to eq(false)
    end
  end
end
