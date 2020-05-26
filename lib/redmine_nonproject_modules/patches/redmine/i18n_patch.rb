# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module Redmine
      module I18nPatch
        def l(*args)
          if (args.first.is_a?(Time) || args.first.is_a?(Date)) && args.last.is_a?(Hash)
            ::I18n.l(args.first, args.last)
          else
            super(*args)
          end
        end
      end
    end
  end
end

x = ::Redmine::I18n
y = ::RedmineNonprojectModules::Patches::Redmine::I18nPatch

x.send(:prepend, y) unless x.included_modules.include?(y)
