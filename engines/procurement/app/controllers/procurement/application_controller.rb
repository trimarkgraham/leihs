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

      if current_user \
        and Procurement::Group.inspector_of_any_group_or_admin?(current_user)
        redirect_to overview_requests_path
      elsif procurement_requester?
        redirect_to overview_user_requests_path(current_user)
      end
    end

    protected

    helper_method :procurement_admin?, :procurement_requester?

    def procurement_admin?
      current_user and (Access.admin?(current_user) \
        or (Access.admins.empty? and admin?))
    end

    def procurement_requester?
      current_user and Access.requesters.where(user_id: current_user).exists?
    end

    private

    def authorize_if_admins_exist
      authorize 'procurement/application'.to_sym, :admins_defined?
    end

    def user_not_authorized(exception)
      case exception.query

      when :authenticated?
        flash[:error] = _('You are not logged in')
        redirect_to root_path

      when :admins_defined?
        flash[:error] = _('No admins defined yet')
        redirect_to (procurement_admin? ? users_path : root_path)

      when :current_budget_period_defined?
        flash.now[:error] = _('Current budget period not defined yet')
        redirect_to budget_periods_path if procurement_admin?

      end
    end
  end
end
