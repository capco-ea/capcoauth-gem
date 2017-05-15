$:.push File.expand_path('../lib', __FILE__)

require 'capcoauth/version'

Gem::Specification.new do |s|
  s.name        = 'capcoauth'
  s.version     = Capcoauth.gem_version.to_s
  s.authors     = ['Adam Robertson']
  s.email       = %w'adam.robertson@capco.com'
  s.homepage    = 'https://github.com/arcreative/capcoauth-gem'
  s.summary     = 'Integration with Capcoauth authentication service'
  s.description = 'capcoauth-gem is a library to integrate Rails applications with Capcoauth authentication service'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split('\n')
  # s.test_files    = `git ls-files -- spec/*`.split('\n')
  s.require_paths = ['lib']
  
  s.required_ruby_version = '>= 2.1'

  s.add_dependency 'railties', ['>= 4.2', '< 6.0']
  s.add_dependency 'activesupport', '>= 3.0'
  s.add_dependency 'httparty', '~> 0.14'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner', '~> 1.5.3'
  s.add_development_dependency 'factory_girl', '~> 4.7.0'
  s.add_development_dependency 'generator_spec', '~> 0.9.3'
  s.add_development_dependency 'rake', '>= 11.3.0'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'timecop', '~> 0.8.1'
end
