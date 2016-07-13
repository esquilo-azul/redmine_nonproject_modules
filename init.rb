# coding: utf-8

require 'redmine'

require 'redmine_nonproject_modules/patches/controller_patch'
require 'redmine_nonproject_modules/patches/group_patch'

Redmine::Plugin.register :redmine_nonproject_modules do
  name 'Redmine non-project modules'
  author 'Eduardo Henrique Bogoni'
  description 'Customizações para a SJAP'
  version '0.0.1'
  url 'https://github.com/eduardobogoni/redmine_nonproject_modules'
  author_url 'https://github.com/eduardobogoni'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :group_permissions, { controller: 'group_permissions', action: 'index' },
              caption: :label_group_permission_plural
  end
end
