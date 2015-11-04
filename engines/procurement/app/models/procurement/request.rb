module Procurement
  class Request < ActiveRecord::Base

    belongs_to :user
    belongs_to :group

    has_many :attachments, dependent: :destroy
    accepts_nested_attributes_for :attachments

    monetize :price_cents

    validates_presence_of :user, :description, :desired_quantity
    validates_numericality_of :approved_quantity, less_than_or_equal_to: :desired_quantity, allow_nil: true
    validates_numericality_of :order_quantity, less_than_or_equal_to: :approved_quantity, allow_nil: true

    #################################################################

    # scope :current, -> { by_budget_period(BudgetPeriod.current) }

    # scope :past, -> {
    #   if previous = BudgetPeriod.current.previous
    #     where("created_at <= ?", previous.end_date.at_end_of_day)
    #   else
    #     none
    #   end
    # }

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

    #################################################################

    def budget_period
      BudgetPeriod.order(end_date: :asc).where("end_date >= ?", created_at).first
    end

    def current?
      # Request.current.where(id: self).exists?
      budget_period.current?
    end

    def editable?(user)
      current? and
          (group.inspectable_by?(user) or
              (user_id == user.id and budget_period.in_requesting_phase?))
    end

    def status(user)
      if not group.inspectable_by?(user) and
          (budget_period.in_inspection_phase? or
              (budget_period.in_requesting_phase? and
                  not approved_quantity.nil?))
        :in_inspection
      else
        if approved_quantity.nil?
          :new
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
    end

    def total_price # TODO optimize for the phases
      price * (order_quantity || approved_quantity || desired_quantity)
    end

  end
end
