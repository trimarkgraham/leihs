module Procurement
  class ApplicationController < ActionController::Base
    include MainHelpers

    before_filter do
      not_authorized!(redirect_path: main_app.root_path) unless is_admin?
    end

    before_action :require_current_budget_period

    private

    def require_current_budget_period
      redirect_to budget_periods_path unless BudgetPeriod.current
    end
  end
end
