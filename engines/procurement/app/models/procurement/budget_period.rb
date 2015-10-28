module Procurement
  class BudgetPeriod < ActiveRecord::Base
    include ActionView::Helpers::DateHelper


    validates_presence_of :name, :inspection_start_date, :end_date

    def to_s
      "%s (%s)" % [name, phase]
    end

    def phase
      "%s phase until %s in %s" % if in_requesting_phase?
                             [_('requesting'), I18n.l(inspection_start_date), distance_of_time_in_words_to_now(inspection_start_date)]
                           else
                             [_('inspection'), I18n.l(end_date), distance_of_time_in_words_to_now(end_date)]
                           end
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

    class << self

      def current
        order(end_date: :asc).where("end_date >= CURDATE()").first
      end

    end

  end
end
