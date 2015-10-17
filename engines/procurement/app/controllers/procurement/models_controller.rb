require_dependency "procurement/application_controller"

module Procurement
  class ModelsController < ApplicationController

    def index
      respond_to do |format|
        format.json { render json: Model.filter(params).to_json(only: :id, methods: :name) }
      end
    end

  end
end
