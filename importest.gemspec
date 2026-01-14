# frozen_string_literal: true

require_relative 'lib/importest/version'

Gem::Specification.new do |spec|
  spec.name        = 'importest'
  spec.version     = Importest::VERSION
  spec.authors     = ['Yann Guillon']
  spec.email       = 'yann@dockdev.com'
  spec.summary     = 'Adds importest option to Rails JavaScript generators'
  spec.description = 'Extends rails new --js to support deno for testing only'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'railties', '>= 6.0.0'
end
