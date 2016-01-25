require_dependency 'procurement/application_controller'

module Procurement
  class BudgetPeriodsController < ApplicationController

    before_action :require_admin_role

    def index
      @budget_periods = BudgetPeriod.order(end_date: :asc)

      unless BudgetPeriod.current
        flash.now[:error] = _('Current budget period not defined yet')
      end
    end

    def create
      errors = params.require(:budget_periods).map do |param|
        permitted = param.permit(:name, :inspection_start_date, :end_date)
        unless param[:id].blank?
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
        flash[:success] = _('Saved')
        head status: :ok
      else
        render json: errors, status: :internal_server_error
      end
    end

    def destroy
      BudgetPeriod.find(params[:id]).destroy
      redirect_to budget_periods_path
    end

  end
end