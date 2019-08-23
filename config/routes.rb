# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  resources(:group_permissions, only: %i[index show update])
  resources(:nonproject_modules, only: [:index])
  get '/group/:id/merge', to: 'group_merge#index', as: :merge_group
  post '/group/:id/merge_check', to: 'group_merge#check', as: :merge_check_group
  post '/group/:id/merge_confirm', to: 'group_merge#confirm', as: :merge_confirm_group
end
