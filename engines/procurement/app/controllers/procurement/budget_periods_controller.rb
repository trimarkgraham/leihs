require_dependency "procurement/application_controller"

module Procurement
  class BudgetPeriodsController < ApplicationController

    def index
      @budget_periods = BudgetPeriod.order(end_date: :asc)

      unless BudgetPeriod.current
        flash.now[:error] = _('Current budget period not defined yet')
      end
    end

    def create
      errors = params.require(:budget_periods).map do |param|
        permitted = param.permit(:name, :inspection_start_date, :end_date)
        if param[:id]
          bp = BudgetPeriod.find(param[:id])
          if permitted.values.all? &:blank?
            bp.destroy
          else
            bp.update_attributes(permitted)
          end
        else
          next if permitted.values.all? &:blank?
          bp = BudgetPeriod.create(permitted)
        end
        bp.errors.full_messages
      end.flatten.compact

      if errors.empty?
        flash[:success] = _("Saved")
        head status: :ok
      else
        render json: errors, status: :internal_server_error
      end
    end

  end
end
