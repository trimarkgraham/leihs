module Procurement
  class ApplicationController < ActionController::Base
    include MainHelpers
    include Pundit

    before_action except: :root do
      authorize 'procurement/application'.to_sym, :authenticated?
    end

    before_action :authorize_if_admins_exist, except: :root

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def root
      authorize 'procurement/application'.to_sym, :current_budget_period_defined?

      if current_user
        if Procurement::Group.inspector_of_any_group_or_admin?(current_user)
          redirect_to overview_requests_path
        else procurement_requester?
          redirect_to overview_user_requests_path(current_user)
        end
      end
    end

    protected

    helper_method :procurement_admin?, :procurement_requester?

    def procurement_admin?
      DefaultPolicy.new(current_user).procurement_admin?
    end

    def procurement_requester?
      DefaultPolicy.new(current_user).procurement_requester?
    end

    private

    def authorize_if_admins_exist
      authorize 'procurement/application'.to_sym, :admins_defined?
    end

    def user_not_authorized(exception)
      case exception.query

      when :authenticated?
        flash[:error] = _('You are not logged in')
        redirect_to root_path and return

      when :admins_defined?
        flash[:error] = _('No admins defined yet')
        if procurement_admin?
          redirect_to users_path and return
        end

      when :current_budget_period_defined?
        flash.now[:error] = _('Current budget period not defined yet')
        if procurement_admin?
          redirect_to budget_periods_path and return
        end

      end

      redirect_to root_path # default
    end
  end
end
