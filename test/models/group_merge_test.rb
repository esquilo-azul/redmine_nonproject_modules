# frozen_string_literal: true

require 'test_helper'

class GroupMergeTest < ActiveSupport::TestCase
  fixtures :projects, :roles, :users

  setup do
  end

  def test_save
    gs = ::Group.create!(name: 'Fonte')
    gt = ::Group.create!(name: 'Target')

    u1 = ::User.find(5)
    u2 = ::User.find(6)
    gs.users << u1
    gs.users << u2

    gt.users << u2
    u3 = ::User.find(7)
    gt.users << u3

    p1 = ::Project.find(1)
    r1 = ::Role.find(1)
    m1 = create_member(p1, gs, r1)

    gp1 = 'group_permissions'
    gp2 = 'group_merge'
    ::GroupPermission.create!(group: gs, permission: gp1)
    ::GroupPermission.create!(group: gt, permission: gp2)

    assert_equal 2, gs.users.count
    assert gs.users.include?(u1)
    assert gs.users.include?(u2)
    assert_equal 1, gs.memberships.count
    assert gs.memberships.include?(m1)
    assert_equal 1, gs.permissions.count
    assert gs.permissions.pluck(:permission).include?(gp1)

    assert 2, gs.users.count
    assert gt.users.include?(u2)
    assert gt.users.include?(u3)
    assert_equal 0, gt.memberships.count
    assert_equal 1, gt.permissions.count
    assert gt.permissions.pluck(:permission).include?(gp2)

    assert ::Group.exists?(gs.id)
    ::GroupMerge.new(source: gs, target: gt).save!
    gt.reload
    assert_equal 3, gt.users.count
    assert gt.users.include?(u1)
    assert gt.users.include?(u2)
    assert gt.users.include?(u3)
    assert_equal 1, gt.memberships.count
    assert gt.memberships.include?(m1)
    assert_equal 2, gt.permissions.count
    assert gt.permissions.pluck(:permission).include?(gp1)
    assert gt.permissions.pluck(:permission).include?(gp2)
    assert_not ::Group.exists?(gs.id)
  end

  def test_to_merge_elements
    gs = ::Group.create!(name: 'Fonte')
    gt = ::Group.create!(name: 'Target')

    u1 = ::User.find(5)
    u2 = ::User.find(6)
    gs.users << u1
    gs.users << u2

    gt.users << u2
    u3 = ::User.find(7)
    gt.users << u3

    assert_equal 2, gs.users.count
    assert gs.users.include?(u1)
    assert gs.users.include?(u2)

    assert 2, gs.users.count
    assert gt.users.include?(u2)
    assert gt.users.include?(u3)

    es = ::GroupMerge.new(source: gs, target: gt).to_merge_elements
    assert_equal 3, es.count
    [[u1, ::GroupMerge::ONLY_ON_SOURCE],
     [u2, ::GroupMerge::ON_BOTH],
     [u3, ::GroupMerge::ONLY_ON_TARGET]].each do |x|
      assert es.include?(x), es
    end
  end

  private

  def create_member(project, group, *roles)
    Member.create!(project_id: project.id, user_id: group.id, role_ids: roles.map(&:id))
  end
end
