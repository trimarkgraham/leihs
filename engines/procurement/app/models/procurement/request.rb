module Procurement
  class Request < ActiveRecord::Base

    belongs_to :budget_period
    belongs_to :user
    belongs_to :group

    has_many :attachments, dependent: :destroy, inverse_of: :request
    accepts_nested_attributes_for :attachments

    monetize :price_cents

    before_validation do
      self.order_quantity ||= approved_quantity
    end

    validates_presence_of :user, :model_description, :requested_quantity
    validates_presence_of :inspection_comment, if: Proc.new {|r| r.approved_quantity and r.approved_quantity < r.requested_quantity }
    validates_numericality_of :order_quantity, less_than_or_equal_to: :approved_quantity, allow_nil: true

    #################################################################

    def editable?(user)
      (budget_period.in_requesting_phase? and (user_id == user.id or group.inspectable_by?(user))) or
        (budget_period.in_inspection_phase? and group.inspectable_by?(user))
    end

    def state(user)
      if budget_period.past? or group.inspectable_or_readable_by?(user)
        if approved_quantity.nil?
          :new
        elsif approved_quantity == 0
          :denied
        elsif 0 < approved_quantity and approved_quantity < requested_quantity
          :partially_approved
        elsif approved_quantity >= requested_quantity
          :approved
        else
          raise
        end
      else
        if budget_period.in_inspection_phase?
          :in_inspection
        else
          :new
        end
      end
    end

    def total_price(current_user)
      quantity = if (not budget_period.in_requesting_phase?) or group.inspectable_or_readable_by?(current_user)
                   order_quantity || approved_quantity || requested_quantity
                 else
                   requested_quantity
                 end
      price * quantity
    end

    #####################################################

    def self.csv_export(requests, current_user)
      require 'csv'

      objects = []
      requests.each do |request|
        show_all = (not request.budget_period.in_requesting_phase?) or request.group.inspectable_or_readable_by?(current_user)
        objects << {
            _('Budget period') => request.budget_period,
            _('Procurement group') => request.group,
            _('Requester') => request.user,
            _('Model name') => request.model_description,
            _('Supplier') => request.supplier,
            _('Requested quantity') => request.requested_quantity,
            _('Approved quantity') => (show_all ? request.approved_quantity : nil),
            _('Order quantity') => (show_all ? request.order_quantity : nil),
            ("%s %s" % [_('Price'), _('incl. VAT')]) => request.price,
            ("%s %s" % [_('Total'), _('incl. VAT')]) => request.total_price(current_user),
            _('State') => request.state(current_user),
            _('Priority') => request.priority,
            _('Name of receiver') => request.receiver,
            _('Department') => request.department,
            _('Motivation') => request.motivation,
            _('Inspection comment') => (show_all ? request.inspection_comment : nil)
        }
      end

      csv_header = objects.flat_map(&:keys).uniq

      CSV.generate({col_sep: ';', quote_char: "\"", force_quotes: true, headers: :first_row}) do |csv|
        csv << csv_header
        objects.each do |object|
          csv << csv_header.map {|h| object[h] }
        end
      end
    end

  end
end
