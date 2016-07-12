RedmineApp::Application.routes.draw do
  resources(:group_permissions, only: [:index, :show, :update])
end
