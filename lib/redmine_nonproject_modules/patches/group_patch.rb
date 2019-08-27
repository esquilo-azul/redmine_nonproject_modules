# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module GroupPatch
      def self.included(base)
        base.class_eval do
          has_many :permissions, class_name: 'GroupPermission', dependent: :destroy
        end
        base.include(InstanceMethods)
      end

      module InstanceMethods
        def add_permission(permission)
          permission = permission.permission if permission.is_a?(::GroupPermission)
          return if permissions.pluck(:permission).include?(permission)

          ::GroupPermission.create!(group: self, permission: permission)
        end
      end
    end
  end
end

unless ::Group.included_modules.include?(RedmineNonprojectModules::Patches::GroupPatch)
  ::Group.send(:include, RedmineNonprojectModules::Patches::GroupPatch)
end
