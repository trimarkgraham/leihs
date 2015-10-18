module Procurement
  class BudgetPeriod < ActiveRecord::Base
    include ActionView::Helpers::DateHelper


    validates_presence_of :name, :inspection_start_date, :end_date

    def to_s
      "%s (%s)" % [name, phase]
    end

    def phase
      "%s phase until %s in %s" % if Date.today < inspection_start_date
                             [_('requesting'), I18n.l(inspection_start_date), distance_of_time_in_words_to_now(inspection_start_date)]
                           else
                             [_('inspection'), I18n.l(end_date), distance_of_time_in_words_to_now(end_date)]
                           end
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
