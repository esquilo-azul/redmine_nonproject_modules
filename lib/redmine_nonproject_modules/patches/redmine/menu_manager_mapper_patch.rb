# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module Redmine
      module MenuManagerMapperPatch
        def push_controller(*)
          e = ::RedmineNonprojectModules::MenuControllerEntry.new(*)
          push(*e.build)
          e.permissions.each do |p|
            ::GroupPermission.add_permission(p)
          end
        end

        # @param plugin_id [Symbol]
        # @param options [Hash]
        # @return [void]
        # @raise [Redmine::PluginNotFound]
        # @raise [ArgumentError]
        def push_plugin_settings(plugin_id = menu, options = {})
          push(
            *::RedmineNonprojectModules::MenuPluginSettingsEntry
              .new(::Redmine::Plugin.find(plugin_id), options).build
          )
        end
      end
    end
  end
end
