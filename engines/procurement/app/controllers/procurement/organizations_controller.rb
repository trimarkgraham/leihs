require_dependency 'procurement/application_controller'

module Procurement
  class OrganizationsController < ApplicationController

    before_action :require_admin_role

    def index
      @organizations = Organization.roots
    end

    def new
      @organization = Organization.new
      render :edit
    end

    def create
      Organization.create(params[:organization])
      redirect_to organizations_path
    end

    before_action only: [:edit, :update] do
      @organization = Organization.find(params[:id])
    end

    def edit
    end

    def update
      @organization.update_attributes(params[:organization])
      redirect_to organizations_path
    end

  end
end
