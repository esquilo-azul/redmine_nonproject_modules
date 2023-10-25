# frozen_string_literal: true

require 'redmine/i18n'

module RedmineNonprojectModules
  module Patches
    module Redmine
      module I18nPatch
        common_concern do
          alias_method :original_l, :l
          alias_method :l, :fixed_l
        end

        def fixed_l(*args)
          if (args.first.is_a?(Time) || args.first.is_a?(Date)) && args.last.is_a?(Hash)
            ::I18n.l(args.first, args.last)
          else
            original_l(*args)
          end
        end
      end
    end
  end
end

x = Redmine::I18n
y = RedmineNonprojectModules::Patches::Redmine::I18nPatch

x.send(:include, y) unless x.included_modules.include?(y)
