# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_nonproject_modules/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_nonproject_modules'
  s.version     = RedmineNonprojectModules::VERSION
  s.authors     = [RedmineNonprojectModules::VERSION]
  s.summary     = RedmineNonprojectModules::SUMMARY
  s.homepage    = RedmineNonprojectModules::HOMEPAGE

  s.files = Dir['{app,config,lib}/**/*', 'init.rb']
  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency 'eac_active_scaffold', '~> 0.8'
  s.add_dependency 'eac_rails_utils', '~> 0.27'
  s.add_dependency 'eac_ruby_utils', '~> 0.130'
  s.add_dependency 'i18n-recursive-lookup', '~> 0.0', '>= 0.0.5'
  s.add_dependency 'jquery-rails', '~> 4.6', '>= 4.6.1'

  # Test/development gems
  s.add_development_dependency 'eac_rails_gem_support', '~> 0.11', '>= 0.11.1'
end
