module Procurement
  class OrganizationPolicy < ApplicationPolicy
    def index?
      admin?
    end
  end
end
