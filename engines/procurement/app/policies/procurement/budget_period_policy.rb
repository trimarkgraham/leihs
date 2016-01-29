module Procurement
  class BudgetPeriodPolicy < ApplicationPolicy
    def index?
      admin?
    end

    def create?
      admin?
    end

    def destroy?
      admin?
    end

    def not_past?
      not record.past?
    end
  end
end
