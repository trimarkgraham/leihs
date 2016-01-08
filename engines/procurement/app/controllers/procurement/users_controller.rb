require_dependency 'procurement/application_controller'

module Procurement
  class UsersController < ApplicationController

    skip_before_action :require_admins
    # TODO: ?? before_action :require_admin_role if admins empty ??

    def index
      respond_to do |format|
        format.html do
          @requester_accesses = Access.requesters.joins(:user) \
                                  .order('users.firstname')
          @admins = User.not_as_delegations \
                        .joins('INNER JOIN procurement_accesses ON users.id = procurement_accesses.user_id')
                        .where(procurement_accesses: { is_admin: true }).order(:firstname)
        end
        format.json do
          render json: User.not_as_delegations.filter(params) \
                        .to_json(only: [:id, :firstname, :lastname])
        end
      end
    end

    def create
      Access.requesters.delete_all
      params[:requesters].each do |param|
        next if param[:name].blank? or param[:_destroy] == '1'
        access = Access.requesters.find_or_initialize_by(user_id: param[:id])
        parent = Organization.find_or_create_by(name: param[:department])
        organization = parent.children.find_or_create_by(name: param[:organization])
        access.update_attributes(organization: organization)
      end

      # existing_requester_ids = Access.requesters.pluck(:user_id)
      # requester_ids = (params[:requester_ids] || '').split(',').map &:to_i
      # (existing_requester_ids - requester_ids).each do |user_id|
      #   Access.requesters.find_by(user_id: user_id).destroy
      # end
      # (requester_ids - existing_requester_ids).each do |user_id|
      #   Access.requesters.create(user_id: user_id)
      # end

      existing_admin_ids = Access.admins.pluck(:user_id)
      admin_ids = (params[:admin_ids] || '').split(',').map &:to_i
      (existing_admin_ids - admin_ids).each do |user_id|
        Access.admins.find_by(user_id: user_id).destroy
      end
      (admin_ids - existing_admin_ids).each do |user_id|
        Access.admins.create(user_id: user_id)
      end

      flash[:success] = _('Saved')
      redirect_to users_path
    end

  end
end
