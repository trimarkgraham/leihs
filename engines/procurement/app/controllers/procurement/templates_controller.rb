require_dependency "procurement/application_controller"

module Procurement
  class TemplatesController < ApplicationController

    before_action do
      @group = Procurement::Group.find(params[:group_id])
    end

    def index
      @template_categories = @group.template_categories
    end


    def create
      errors = params.require(:template_categories).values.map do |param|
        #param = param.permit(:name, :template_attributes)

        if param[:id]
          r = @group.template_categories.find(param[:id])
          # if param.values.all? &:blank?
          #   r.destroy
          # else
            r.update_attributes(param)
          # end
        else
          next if param[:name].blank?
          # param[:group_id] = params[:group_id]
          r = @group.template_categories.create(param)
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