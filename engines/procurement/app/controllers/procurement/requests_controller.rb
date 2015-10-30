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

    before_action only: [:index, :resume] do
      @requests = Request.all
      @requests = @requests.where(user_id: @user) if @user
      @requests = @requests.where(group_id: @group) if @group
    end

    def index
      @budget_period = BudgetPeriod.find(params[:budget_period_id])
      @requests = @requests.by_budget_period(@budget_period)
    end

    def resume
      @budget_periods = BudgetPeriod.order(end_date: :desc)
    end

    def create
      errors = params.require(:requests).values.map do |param|
        requester_keys = [:group_id, :user_id, :description, :desired_quantity, :price, :supplier, attachments_attributes: [:file]]
        inspector_keys = [:approved_quantity]
        keys = requester_keys + inspector_keys # TODO check role # request_template.inspectable_by?(current_user)
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
        flash[:success] = _("Saved")
        head status: :ok
      else
        render json: errors, status: :internal_server_error
      end
    end

  end
end
