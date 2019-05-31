# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module Redmine
      module I18nPatch
        def self.included(base)
          base.include(InstanceMethods)
          base.alias_method_chain :l, :active_scaffold
        end

        module InstanceMethods
          def l_with_active_scaffold(*args)
            if (args.first.is_a?(Time) || args.first.is_a?(Date)) && args.last.is_a?(Hash)
              ::I18n.l(args.first, args.last)
            else
              l_without_active_scaffold(*args)
            end
          end
        end
      end
    end
  end
end

x = ::Redmine::I18n
y = ::RedmineNonprojectModules::Patches::Redmine::I18nPatch

x.send(:include, y) unless x.included_modules.include?(y)
