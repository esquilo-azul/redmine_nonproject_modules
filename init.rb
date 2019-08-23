# frozen_string_literal: true

require 'active_scaffold'

require 'redmine'

require 'redmine_nonproject_modules/patches/controller_patch'
require 'redmine_nonproject_modules/patches/group_patch'
require 'redmine_nonproject_modules/patches/redmine/i18n_patch'
require 'redmine_nonproject_modules/patches/redmine/menu_manager_patch'
require 'redmine_nonproject_modules/version'

Redmine::Plugin.register :redmine_nonproject_modules do
  name 'Redmine non-project modules'
  author ::RedmineNonprojectModules::AUTHOR
  description ::RedmineNonprojectModules::SUMMARY
  version ::RedmineNonprojectModules::VERSION
  url ::RedmineNonprojectModules::HOMEPAGE
  author_url 'https://github.com/eduardobogoni'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :group_permissions, { controller: 'group_permissions', action: 'index' },
              caption: :label_group_permission_plural, after: :groups,
              if: proc { GroupPermission.permission?('group_permissions') }
  end

  Redmine::MenuManager.map :top_menu do |menu|
    menu.push :nonproject_modules, { controller: 'nonproject_modules', action: 'index', id: nil },
              caption: :label_nonproject_modules
  end

  ActiveScaffold.delayed_setup = true
end

Rails.configuration.to_prepare do
  GroupPermission.add_permission('group_permissions')
  GroupPermission.add_permission('group_merge')
  require_dependency 'redmine_nonproject_modules/patches/user_patch'
end
