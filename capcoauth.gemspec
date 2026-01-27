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

  s.required_ruby_version = '>= 3'

  s.add_dependency 'httparty', '~> 0.24.2'
end
