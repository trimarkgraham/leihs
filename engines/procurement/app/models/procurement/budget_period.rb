module Procurement
  class BudgetPeriod < ActiveRecord::Base

    validates_presence_of :name, :inspection_start_date, :end_date

    def to_s
      name
    end

    def in_requesting_phase?
      Date.today < inspection_start_date
    end

    def in_inspection_phase?
      inspection_start_date <= Date.today and Date.today <= end_date
    end

    def status_counts(user: nil, group: nil)
      requests = Request.by_budget_period(self)
      requests = requests.where(user_id: user) if user
      requests = requests.where(group_id: group) if group
      {
          new: requests.where(approved_quantity: nil).count,
          denied: requests.where(approved_quantity: 0).count,
          partially_approved: requests.where('0 < approved_quantity AND approved_quantity < desired_quantity').count,
          completely_approved: requests.where('approved_quantity = desired_quantity').count
      }
    end

    def previous
      self.class.order(end_date: :desc).where("end_date < ?", end_date).first
    end

    def current?
      Date.today <= end_date and (previous.nil? or Date.today > previous.end_date)
    end

    class << self

      def current
        order(end_date: :asc).where("end_date >= CURDATE()").first
      end

    end

  end
end
