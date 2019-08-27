# frozen_string_literal: true

class GroupMergeController < ApplicationController
  require_permission 'group_merge'
  helper GroupMergeHelper

  def index
    @group_merge = ::GroupMerge.new(source: ::Group.find(params[:id]))
    build_targets_list
  end

  def check
    @group_merge = ::GroupMerge.new(check_parameters)
    return if @group_merge.valid?

    build_targets_list
    render :index
  end

  def confirm
    @group_merge = ::GroupMerge.new(check_parameters)
    @group_merge.save!
    path = GroupPermission.permission?('group_permissions') ? group_permissions_path : root_path
    redirect_to path, notice: t(:notice_successful_update)
  end

  private

  def check_parameters
    params[:group_merge].permit(:target_id).merge(source: ::Group.find(params[:id]))
  end

  def build_targets_list
    @targets_list = Group.where.not(id: @group_merge.source.id).sorted.map do |g|
      [g.to_s, g.id]
    end
  end
end
