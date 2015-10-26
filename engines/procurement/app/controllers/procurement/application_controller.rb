module Procurement
  class ApplicationController < ActionController::Base
    include MainHelpers

    # TODO before_action :require_login, :require_admins, except: :root

    def root
      # TODO
      redirect_to budget_periods_path
    end

    protected

    def is_procurement_admin?
      Access.admins.where(user_id: current_user).exists?
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
        if is_admin?
          redirect_to users_path
        else
          redirect_to root_path
        end
      end
    end

  end
end
