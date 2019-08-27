# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module UserPatch
      def self.included(base)
        base.include(InstanceMethods)
      end

      module InstanceMethods
        def permission?(permissions)
          GroupPermission.permission?(permissions, self)
        end
      end
    end
  end
end

unless ::User.included_modules.include?(RedmineNonprojectModules::Patches::UserPatch)
  ::User.send(:include, RedmineNonprojectModules::Patches::UserPatch)
end
