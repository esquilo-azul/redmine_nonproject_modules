# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module RedmineNonprojectModules
  class MenuControllerEntry
    # @!method initialize(controller, options = {})
    # @param controller [String]
    # @param options [Hash]
    common_constructor :controller, :options, default: [{}] do
      self.controller = controller.to_s
      self.options = options.with_indifferent_access
    end

    def build
      [build_name, build_url, build_options]
    end

    def permissions
      parse_permissions(permissions_const)
    end

    private

    def build_name
      r = controller
      r = "#{r}_#{action}" unless action == 'index'
      r.to_sym
    end

    def build_url
      { controller: controller, action: action, id: id }
    end

    def build_options
      {
        caption: build_caption,
        if: proc { GroupPermission.permission?(permissions_const) }
      }
    end

    def build_caption
      :"label_#{build_name}"
    end

    def controller_class
      Object.const_get("#{controller.camelize}Controller")
    end

    def action
      options[:action] || 'index'
    end

    def id
      options[:id]
    end

    def permissions_const
      controller_class.const_get('PERMISSIONS')
    end

    def parse_permissions(permission)
      return parse_permissions(permission.values) if permission.is_a?(Hash)
      return permission.flat_map { |v| parse_permissions(v) } if permission.is_a?(Enumerable)

      [permission.to_s]
    end
  end
end
