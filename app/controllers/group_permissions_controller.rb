# frozen_string_literal: true

class GroupPermissionsController < ApplicationController
  require_permission 'group_permissions'
  before_action :set_group, only: %i[show update]

  def index
    @groups = Group.sorted
  end

  def show
    @gps = GroupPermissionsSetup.new(group: @group)
  end

  def update
    @gps = GroupPermissionsSetup.new(gps_params)
    if @gps.save
      redirect_to group_permission_path(@group), notice: t(:notice_successful_update)
    else
      render :show
    end
  end

  private

  def gps_params
    p = { permissions: [], group: @group }
    if params[:group_permissions_setup] && params[:group_permissions_setup][:permissions]
      p[:permissions] = params[:group_permissions_setup][:permissions]
    end
    p
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
