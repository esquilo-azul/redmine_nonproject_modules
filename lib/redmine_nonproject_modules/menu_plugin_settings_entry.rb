# frozen_string_literal: true

module RedmineNonprojectModules
  class MenuPluginSettingsEntry
    NAME = :plugin_settings

    # @!method initialize(plugin, options = {})
    # @param plugin [Redmine::Plugin]
    # @param options [Hash]
    # @raise [ArgumentError]
    common_constructor :plugin, :options, default: [{}] do
      raise ArgumentError, "Plugin \"#{plugin.id}\" is not configurable" unless
        plugin.configurable?
    end

    # @return [Array(Symbol, Hash, Hash)]
    def build
      [NAME, build_url, build_options]
    end

    private

    # @return [Hash]
    def build_url
      { controller: 'settings', action: 'plugin', id: plugin.id.to_s }
    end

    # @return [Hash]
    def build_options
      {
        caption: :label_settings, icon: 'settings', html: { class: 'icon icon-settings' },
        if: proc { User.current.admin? }
      }.merge(options)
    end
  end
end
