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

  s.add_dependency 'active_scaffold', '~> 3.5'
  s.add_dependency 'activemodel-associations'
  s.add_dependency 'eac_rails_utils', '~> 0.11', '>= 0.11.2'
  s.add_dependency 'eac_ruby_utils', '~> 0.33'
  s.add_dependency 'jquery-rails', '~> 4.4'
  s.add_dependency 'virtus'
end
