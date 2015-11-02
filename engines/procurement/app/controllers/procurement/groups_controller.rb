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
      Group.create(params[:group])
      redirect_to groups_path
    end

    before_action only: [:edit, :update, :destroy] do
      @group = Group.find(params[:id])
    end

    def edit
    end

    def update
      @group.update_attributes(params[:group])
      redirect_to groups_path
    end

    def destroy
      @group.destroy
      redirect_to groups_path
    end

  end
end
