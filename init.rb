# coding: utf-8

require 'redmine'

require 'redmine_nonproject_modules/patches/controller_patch'

Redmine::Plugin.register :redmine_nonproject_modules do
  name 'Redmine non-project modules'
  author 'Eduardo Henrique Bogoni'
  description 'Customizações para a SJAP'
  version '0.0.1'
  url 'https://github.com/eduardobogoni/redmine_nonproject_modules'
  author_url 'https://github.com/eduardobogoni'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :group_permissions, { controller: 'group_permissions', action: 'index' },
              caption: :label_group_permission_plural, after: :groups,
              if: proc { GroupPermission.permission?('group_permissions') }
  end
end

Rails.configuration.to_prepare do
  GroupPermission.add_permission('group_permissions')
end
