require 'test_helper'
require 'action_dispatch/routing/inspector'

class MyDummyController < ApplicationController
  require_permission 'dummy_permission'

  def index
    render text: 'Ok!'
  end
end

class GroupPermissionTest < ActionController::TestCase
  fixtures :users

  def setup
    @controller = MyDummyController.new
    @routes.disable_clear_and_finalize = true
    @routes.draw do
      resources(:my_dummy, only: [:index])
    end
    @routes.disable_clear_and_finalize = false
    assert_generates '/my_dummy', controller: 'my_dummy', action: 'index'
    GroupPermission.add_permission('dummy_permission')
  end

  def test_permissions_setup
    no_admin = users(:users_002)

    @request.session[:user_id] = no_admin.id # no admin
    assert_not GroupPermission.permission?('dummy_permission')
    get :index
    assert_response 403

    @request.session[:user_id] = 1 # admin
    get :index
    assert_response :success

    g = Group.create!(name: 'My group')
    with_controller(GroupPermissionsController) do
      put :update, id: g.id, 'group_permissions_setup' => { permissions: ['dummy_permission'] }
      assert_redirected_to group_permission_path(g)
      assert assigns(:gps)
      assert_equal ['dummy_permission'], assigns(:gps).permissions
    end
    assert_not GroupPermission.permission?('dummy_permission', no_admin)

    no_admin.groups << g
    assert GroupPermission.permission?('dummy_permission', no_admin)

    with_controller(AccountController) do
      get :logout
    end

    @request.session[:user_id] = no_admin.id # no admin
    get :index
    assert_response :success
  end

  private

  def with_controller(controller_class, &block)
    old_controller = @controller
    begin
      @controller = controller_class.new
      block.call
    ensure
      @controller = old_controller
    end
  end
end
