# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module Redmine
      module MenuManagerMapperPatch
        def push_controller(*args)
          e = ::RedmineNonprojectModules::MenuControllerEntry.new(*args)
          push(*e.build)
          e.permissions.each do |p|
            ::GroupPermission.add_permission(p)
          end
        end
      end
    end
  end
end

Redmine::MenuManager::Mapper
  .include(RedmineNonprojectModules::Patches::Redmine::MenuManagerMapperPatch)
