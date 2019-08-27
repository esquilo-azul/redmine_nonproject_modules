# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module ControllerPatch
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end

      module ClassMethods
        def require_permission(permission, options = {})
          before_action(options) { |c| c.before_action_require_permission(permission) }
        end
      end

      module InstanceMethods
        def before_action_require_permission(permission)
          return true if GroupPermission.permission?(permission)

          deny_access
        end
      end
    end
  end
end

unless ActionController::Base.included_modules.include?(
  RedmineNonprojectModules::Patches::ControllerPatch
)
  ActionController::Base.send(:include, RedmineNonprojectModules::Patches::ControllerPatch)
end
