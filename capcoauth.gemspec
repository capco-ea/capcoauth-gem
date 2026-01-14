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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.1'

  s.add_dependency 'railties', '>= 4.2'
  s.add_dependency 'activesupport', '>= 3.0'
  s.add_dependency 'httparty', '~> 0.24.0'
  s.add_dependency 'csv'

  s.add_development_dependency 'database_cleaner', '~> 2.0.1'
  s.add_development_dependency 'generator_spec', '~> 0.9.4'
  s.add_development_dependency 'rake', '>= 13.0.6'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'timecop', '~> 0.9.5'
end
