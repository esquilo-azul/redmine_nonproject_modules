# frozen_string_literal: true

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
    GroupPermission.add_permission('include', dependencies: [:dummy_permission])
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
      put :update, params: { id: g.id, 'group_permissions_setup' =>
          { permissions: ['dummy_permission'] } }
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

  test 'depends permission' do
    no_admin = users(:users_002)
    g = Group.create!(name: 'My group')
    g.users << no_admin
    assert_dummy_includes(no_admin, false, false)
    GroupPermission.create!(group: g, permission: 'dummy_permission')
    assert_dummy_includes(no_admin, true, false)
    GroupPermission.where(group: g, permission: 'dummy_permission').destroy_all
    assert_dummy_includes(no_admin, false, false)
    GroupPermission.create!(group: g, permission: 'include')
    assert_dummy_includes(no_admin, true, true)
  end

  test 'blocks no existing dependencies' do
    assert_raise do
      ::GroupPermission.add_permission('recursive1', dependencies: %w[not_exist])
    end
  end

  test 'no redefine dependencies' do
    key = 'permission1'
    ::GroupPermission.add_permission(key)
    assert 0, ::GroupPermission.permission(key).dependencies.count
    ::GroupPermission.add_permission(key, dependencies: %w[dummy_permission])
    assert 0, ::GroupPermission.permission(key).dependencies.count
  end

  private

  def assert_dummy_includes(user, dummy, include)
    e = { dummy_permission: dummy, include: include }
    a = Hash[e.keys.map { |p| [p, user.permission?(p)] }]
    assert_equal e, a
  end

  def with_controller(controller_class)
    old_controller = @controller
    begin
      @controller = controller_class.new
      yield
    ensure
      @controller = old_controller
    end
  end
end
