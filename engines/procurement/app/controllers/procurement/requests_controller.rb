require_dependency "procurement/application_controller"

module Procurement
  class RequestsController < ApplicationController

    def index
      @requests = case params[:budget_period]
                    when 'current', 'past'
                      Request.send(params[:budget_period])
                    else
                      Request.all
                  end

      if params[:user_id]
        @user = User.find(params[:user_id])
        @requests = @requests.where(user_id: @user)
      end
    end


    def create
      errors = params.require(:requests).map do |param|
        requester_keys = [:group_id, :description, :desired_quantity, :price, :supplier]
        inspector_keys = [:approved_quantity]
        keys = requester_keys + inspector_keys # TODO check role
        permitted = param.permit(keys)

        if param[:id]
          r = Request.find(param[:id])
          if permitted.values.all? &:blank?
            r.destroy
          else
            r.update_attributes(permitted)
          end
        else
          next if permitted.values.all? &:blank?
          permitted[:user] = current_user
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
