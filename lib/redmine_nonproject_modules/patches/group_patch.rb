module RedmineNonprojectModules
  module Patches
    module GroupPatch
      def self.included(base)
        base.has_many :permissions, class_name: 'GroupPermission', dependent: :destroy
      end
    end
  end
end

unless Group.included_modules.include? RedmineNonprojectModules::Patches::GroupPatch
  Group.send(:include, RedmineNonprojectModules::Patches::GroupPatch)
end
