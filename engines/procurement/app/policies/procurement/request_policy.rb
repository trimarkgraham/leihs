module Procurement
  class RequestPolicy < ApplicationPolicy
    attr_reader :current_user, :request_user

    def initialize(current_user, request_user: nil)
      @current_user = current_user
      @request_user = request_user
    end

    def allowed?
      request_user == current_user or
        Procurement::Group.inspector_of_any_group_or_admin?(current_user)
    end
  end
end

