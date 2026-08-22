# frozen_string_literal: true

# Compatibility shim between ActiveScaffold's JS (expects raw HTML text) and modern rails-ujs
# (auto-parses "text/html" responses into a Document before handing them over).
module RedmineNonprojectModules
  module Patches
    module ActiveScaffoldJsResponse
      # Intercepts "included" on ActiveScaffold::Actions::Core itself, so every controller that
      # later includes it also gets this module and the after_action callback below.
      module SingletonMethods
        def included(base)
          super
          base.include RedmineNonprojectModules::Patches::ActiveScaffoldJsResponse
          base.after_action :fix_active_scaffold_js_response_content_type
        end
      end

      common_concern do
        singleton_class.prepend(RedmineNonprojectModules::Patches::ActiveScaffoldJsResponse::SingletonMethods)
      end

      def fix_active_scaffold_js_response_content_type
        return unless request.format.js? && response.media_type == 'text/html'

        response.content_type = 'text/plain'
      end
    end
  end
end
