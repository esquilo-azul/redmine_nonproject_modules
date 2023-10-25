# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module Redmine
      module MenuManager
        module Mapper
          def self.included(base)
            base.send(:include, InstanceMethods)
          end
        end

        module InstanceMethods
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
end

unless Redmine::MenuManager::Mapper.included_modules.include?(
  RedmineNonprojectModules::Patches::Redmine::MenuManager::Mapper
)
  Redmine::MenuManager::Mapper.include(
    RedmineNonprojectModules::Patches::Redmine::MenuManager::Mapper
  )
end
