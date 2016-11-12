$:.push File.expand_path("../lib", __FILE__)

require 'capcoauth/version'

Gem::Specification.new do |s|
  s.name        = 'capcoauth'
  s.version     = Capcoauth::VERSION
  s.authors     = ['Adam Robertson']
  s.email       = %w'adam.robertson@capco.com'
  s.homepage    = 'https://github.com/arcreative/capcoauth-gem'
  s.summary     = 'Integration with Capcoauth authentication service'
  s.description = 'capcoauth-gem is a library to integrate Rails applications with Capcoauth authentication service'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'railties', ['>= 4.2', '< 6.0']
  s.add_dependency 'activesupport', '>= 3.0'
  s.add_dependency 'httparty', '~> 0.13'

  s.add_development_dependency 'rake', '~> 10.5'
  s.add_development_dependency 'rspec-rails', '~> 3.4'
end
