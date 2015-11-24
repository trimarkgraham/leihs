require_dependency "procurement/application_controller"

module Procurement
  class UsersController < ApplicationController

    skip_before_action :require_admins
    # TODO ?? before_action :require_admin_role if admins empty ??

    def index
      respond_to do |format|
        format.html {
          @requesters = User.not_as_delegations.joins('INNER JOIN procurement_accesses ON users.id = procurement_accesses.user_id').
              where(procurement_accesses: {is_admin: [nil, false]})
          @admins = User.not_as_delegations.joins('INNER JOIN procurement_accesses ON users.id = procurement_accesses.user_id').
              where(procurement_accesses: {is_admin: true})
        }
        format.json { render json: User.not_as_delegations.filter(params).to_json(only: [:id, :firstname, :lastname]) }
      end
    end

    def create
      existing_requester_ids = Access.requesters.pluck(:user_id)
      requester_ids = (params[:requester_ids] || '').split(',').map &:to_i
      (existing_requester_ids - requester_ids).each do |user_id|
        Access.requesters.find_by(user_id: user_id).destroy
      end
      (requester_ids - existing_requester_ids).each do |user_id|
        Access.requesters.create(user_id: user_id)
      end

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
