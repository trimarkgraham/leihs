require_dependency "procurement/application_controller"

module Procurement
  class GroupsController < ApplicationController

    def index
      @groups = Group.all
      respond_to do |format|
        format.html
        format.json { render json: @groups }
      end
    end

    def new
      @group = Group.new
      render :edit
    end

    def create
      update
    end

    before_action only: [:edit, :update] do
      @group = Group.find(params[:id])
    end

    def edit
    end

    def update
      @group ||= Group.new(params[:group])
      @group.update_attributes(params[:group])
      # OPTIMIZE association callback
      params[:group][:responsible_ids].each do |responsible_id|
        @group.group_accesses.find_by(user_id: responsible_id).update_attributes(is_responsible: true)
      end
      redirect_to groups_path
    end

  end
end
