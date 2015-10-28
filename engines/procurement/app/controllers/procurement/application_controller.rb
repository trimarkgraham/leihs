module Procurement
  class ApplicationController < ActionController::Base
    include MainHelpers

    before_action :require_login, :require_admins, except: :root

    def root
    end

    protected

    helper_method :is_procurement_admin?, :is_procurement_requester?

    def is_procurement_admin?
      current_user and (Access.admins.where(user_id: current_user).exists? or (Access.admins.empty? and is_admin?))
    end

    def is_procurement_requester?
      current_user and Access.requesters.where(user_id: current_user).exists?
    end

    private

    def require_login
      unless current_user
        flash[:error] = _('You are not logged in')
        redirect_to root_path
      end
    end

    def require_admins
      if Access.admins.empty?
        flash[:error] = _('No admins defined yet')
        if is_procurement_admin?
          redirect_to users_path
        else
          redirect_to root_path
        end
      end
    end

  end
end
