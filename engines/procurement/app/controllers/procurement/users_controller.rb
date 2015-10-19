require_dependency "procurement/application_controller"

module Procurement
  class UsersController < ApplicationController

    def index
      respond_to do |format|
        format.json { render json: User.filter(params).to_json(only: [:id, :firstname, :lastname]) }
      end
    end

  end
end
