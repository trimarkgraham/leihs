module Procurement
  class Request < ActiveRecord::Base
    belongs_to :user

    validates_presence_of :user, :description, :desired_quantity
    validates_numericality_of :approved_quantity, less_than_or_equal_to: :desired_quantity, allow_nil: true

    scope :current, -> { by_budget_period(BudgetPeriod.current) }

    scope :past, -> {
      if previous = BudgetPeriod.current.previous
        where("created_at <= ?", previous.end_date.at_end_of_day)
      else
        none
      end
    }

    scope :by_budget_period, ->(budget_period) {
      if budget_period
        r = where("created_at <= ?", budget_period.end_date.at_end_of_day)
        if previous = budget_period.previous
          r = r.where("created_at > ?", previous.end_date.at_end_of_day)
        end
        r
      else
        none
      end
    }

    def current?
      Request.current.exists? self
    end

    def status
      if approved_quantity.nil?
        :uninspected
      elsif approved_quantity == 0
        :denied
      elsif 0 < approved_quantity and approved_quantity < desired_quantity
        :partially_approved
      elsif approved_quantity == desired_quantity
        :completely_approved
      else
        raise
      end
    end

    class << self

      def status_counts(budget_period, user: nil)
        requests = by_budget_period(budget_period)
        requests = requests.where(user_id: user) if user
        {
            uninspected: requests.where(approved_quantity: nil).count,
            denied: requests.where(approved_quantity: 0).count,
            partially_approved: requests.where('0 < approved_quantity AND approved_quantity < desired_quantity').count,
            completely_approved: requests.where('approved_quantity = desired_quantity').count
        }
      end

    end

  end
end
