# frozen_string_literal: true

ActiveScaffold::Actions::Core.patch_self(RedmineNonprojectModules::Patches::ActiveScaffoldJsResponse)
ActiveSupport.on_load(:action_controller) do
  include RedmineNonprojectModules::Patches::ControllerPatch
end
Group.include RedmineNonprojectModules::Patches::GroupPatch
Redmine::I18n.patch_self(RedmineNonprojectModules::Patches::Redmine::I18n)
Redmine::MenuManager::Mapper.include(RedmineNonprojectModules::Patches::Redmine::MenuManagerMapperPatch)
Redmine::Plugin.include(RedmineNonprojectModules::Patches::Redmine::Plugin)
User.include RedmineNonprojectModules::Patches::UserPatch
