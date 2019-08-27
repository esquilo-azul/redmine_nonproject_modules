# frozen_string_literal: true

class GroupPermissionsSetup
  include ActiveModel::Model

  attr_accessor :group
  attr_writer :permissions

  def permissions
    @permissions ||= GroupPermission.where(group: group).pluck(:permission)
  end

  def save
    ActiveRecord::Base.transaction do
      GroupPermission.where(group: group).destroy_all
      permissions.each do |p|
        GroupPermission.create!(group: group, permission: p)
      end
    end
    true
  end
end
