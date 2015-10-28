require_dependency "procurement/application_controller"

module Procurement
  class RequestTemplatesController < ApplicationController

    before_action do
      @group = Procurement::Group.find(params[:group_id])
    end

    def index
      @request_templates = @group.request_templates
    end


    def create
      errors = params.require(:request_templates).map do |param|
        permitted = param.permit([:description, :price, :supplier])

        if param[:id]
          r = RequestTemplate.find(param[:id])
          if permitted.values.all? &:blank?
            r.destroy
          else
            r.update_attributes(permitted)
          end
        else
          next if permitted.values.all? &:blank?
          permitted[:group_id] = params[:group_id]
          r = RequestTemplate.create(permitted)
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
