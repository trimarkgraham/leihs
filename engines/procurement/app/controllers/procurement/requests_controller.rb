require_dependency "procurement/application_controller"

module Procurement
  class RequestsController < ApplicationController

    before_action do
      unless BudgetPeriod.current
        if is_procurement_admin?
          redirect_to budget_periods_path
        else
          redirect_to root_path
        end
      end

      @user = User.not_as_delegations.find(params[:user_id]) if params[:user_id]
      @group = Procurement::Group.find(params[:group_id]) if params[:group_id]
    end

    before_action only: [:index, :overview] do
      @requests = Request.all
      @requests = @requests.where(user_id: @user) if @user
      @requests = @requests.where(group_id: @group) if @group
    end

    def index
      @budget_period = BudgetPeriod.find(params[:budget_period_id])
      @requests = @requests.where(budget_period_id: @budget_period)

      respond_to do |format|
        format.html
        format.csv {
          send_data Request.csv_export(@requests, current_user),
                    type: 'text/csv; charset=utf-8; header=present',
                    disposition: "attachment; filename=requests.csv"
        }
      end
    end

    def overview
      @budget_periods = BudgetPeriod.order(end_date: :desc)
    end

    def create
      keys = [:group_id, :user_id, :model_description, :price, :supplier, :motivation, :receiver, :organization_unit, attachments_attributes: [:file]]
      keys += [:desired_quantity, :priority] if @user == current_user
      keys += [:approved_quantity, :order_quantity, :inspection_comment] if @group.inspectable_by?(current_user)

      errors = params.require(:requests).values.map do |param|
        permitted = param.permit(keys)

        if param[:id]
          r = Request.find(param[:id])
          if permitted.values.all?(&:blank?) or permitted[:desired_quantity].to_i.zero?
            r.destroy
          else
            r.update_attributes(permitted)
          end
        else
          next if permitted.values.all?(&:blank?) or permitted[:desired_quantity].to_i.zero?
          permitted[:group_id] = params[:group_id]
          permitted[:user_id] = params[:user_id]
          r = Request.create(permitted)
        end
        r.errors.full_messages
      end.flatten.compact

      if errors.empty?
        flash[:success] = _('Saved')
        head status: :ok
      else
        render json: errors, status: :internal_server_error
      end
    end

  end
end
