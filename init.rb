# frozen_string_literal: true

require 'active_scaffold'
require 'jquery/rails'

require 'redmine'
require 'redmine_nonproject_modules/version'

Redmine::Plugin.register :redmine_nonproject_modules do
  name 'Redmine non-project modules'
  author ::RedmineNonprojectModules::AUTHOR
  description ::RedmineNonprojectModules::SUMMARY
  version ::RedmineNonprojectModules::VERSION
  url ::RedmineNonprojectModules::HOMEPAGE
  author_url 'https://github.com/eduardobogoni'
end
