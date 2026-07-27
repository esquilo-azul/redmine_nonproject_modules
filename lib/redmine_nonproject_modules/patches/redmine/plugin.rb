# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module Redmine
      module Plugin
        common_concern

        def nonprojects_menu(&)
          ::Redmine::MenuManager.map(id, &)
        end
      end
    end
  end
end

Redmine::Plugin.include(RedmineNonprojectModules::Patches::Redmine::Plugin)
