# frozen_string_literal: true

module RedmineNonprojectModules
  module Patches
    module Redmine
      module MenuManagerMapperPatch
        def self.included(base)
          base.send(:include, InstanceMethods)
        end
      end

      module InstanceMethods
        def push_controller(*args)
          e = ControllerEntry.new(*args)
          push(*e.build)
          e.permissions.each do |p|
            ::GroupPermission.add_permission(p)
          end
        end
      end

      class ControllerEntry
        def initialize(controller, options = {})
          @controller = controller.to_s
          @options = options.with_indifferent_access
        end

        def build
          [build_name, build_url, build_options]
        end

        def permissions
          parse_permissions(permissions_const)
        end

        private

        attr_reader :controller, :options

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
          "label_#{build_name}".to_sym
        end

        def controller_class
          Object.const_get("#{controller.camelize}Controller")
        end

        def action
          @options[:action] || 'index'
        end

        def id
          @options[:id]
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
  end
end

unless ::Redmine::MenuManager::Mapper.included_modules.include?(
  ::RedmineNonprojectModules::Patches::Redmine::MenuManagerMapperPatch
)
  ::Redmine::MenuManager::Mapper.send(
    :include, ::RedmineNonprojectModules::Patches::Redmine::MenuManagerMapperPatch
  )
end
