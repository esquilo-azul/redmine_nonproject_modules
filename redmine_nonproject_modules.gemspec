# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_nonproject_modules/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_nonproject_modules'
  s.version     = ::RedmineNonprojectModules::VERSION
  s.authors     = [::RedmineNonprojectModules::VERSION]
  s.summary     = ::RedmineNonprojectModules::SUMMARY
  s.homepage    = ::RedmineNonprojectModules::HOMEPAGE

  s.files = Dir['{app,config,lib}/**/*', 'init.rb']

  s.add_dependency 'eac_active_scaffold', '~> 0.5', '>= 0.5.1'
  s.add_dependency 'eac_rails_utils', '~> 0.21'
  s.add_dependency 'eac_ruby_utils', '~> 0.119', '>= 0.119.2'
  s.add_dependency 'jquery-rails', '~> 4.6'

  # Test/development gems
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5.1'
end
