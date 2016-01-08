module Procurement
  class BudgetPeriod < ActiveRecord::Base

    has_many :requests

    validates_presence_of :name, :inspection_start_date, :end_date
    validates_uniqueness_of :name, :inspection_start_date, :end_date
    validate do
      errors.add(:end_date, _('must be greater or equal to the inspection start date')) if end_date < inspection_start_date
    end

    ####################################################

    scope :future, -> { where('end_date > ?', Date.today) }

    ####################################################

    def to_s
      name
    end

    def in_requesting_phase?
      Date.today < inspection_start_date
    end

    def in_inspection_phase?
      inspection_start_date <= Date.today and Date.today <= end_date
    end

    def state_counts(args)
      requests = self.requests
      requests = requests.where(user_id: args[:user]) if args[:user]
      requests = requests.where(group_id: args[:group]) if args[:group]

      if past? or (args[:group] \
        and args[:group].inspectable_or_readable_by?(args[:current_user]))
        {
          new: requests.where(approved_quantity: nil).count,
          denied: requests.where(approved_quantity: 0).count,
          partially_approved: requests.where('0 < approved_quantity AND approved_quantity < requested_quantity').count,
          approved: requests.where('approved_quantity >= requested_quantity').count
        }
      else
        if in_inspection_phase?
          { in_inspection: requests.count }
        else
          { new: requests.count }
        end
      end
    end

    def previous
      self.class.order(end_date: :desc).find_by('end_date < ?', end_date)
    end

    def current?
      Date.today <= end_date and (previous.nil? or Date.today > previous.end_date)
    end

    def past?
      end_date < Date.today
    end

    class << self

      def current
        order(end_date: :asc).find_by('end_date >= CURDATE()')
      end

    end

  end
end
