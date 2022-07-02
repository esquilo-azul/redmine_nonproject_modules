# frozen_string_literal: true

Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :group_permissions, { controller: 'group_permissions', action: 'index' },
            caption: :label_group_permission_plural, after: :groups,
            if: proc { GroupPermission.permission?('group_permissions') }
end

Redmine::MenuManager.map :top_menu do |menu|
  menu.push :nonproject_modules, { controller: 'nonproject_modules', action: 'index', id: nil },
            caption: :label_nonproject_modules
end
