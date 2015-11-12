module Procurement
  class Request < ActiveRecord::Base

    belongs_to :budget_period
    belongs_to :user
    belongs_to :group

    has_many :attachments, dependent: :destroy
    accepts_nested_attributes_for :attachments

    monetize :price_cents

    before_validation do
      self.order_quantity ||= approved_quantity
    end

    validates_presence_of :user, :model_description, :desired_quantity
    validates_presence_of :inspection_comment, if: Proc.new {|r| r.approved_quantity and r.approved_quantity < r.desired_quantity }
    validates_numericality_of :order_quantity, less_than_or_equal_to: :approved_quantity, allow_nil: true

    #################################################################

    def editable?(user)
      (budget_period.in_requesting_phase? and (user_id == user.id or group.inspectable_by?(user))) or
      (budget_period.in_inspection_phase? and group.inspectable_by?(user))
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
        elsif approved_quantity >= desired_quantity
          :approved
        else
          raise
        end
      end
    end

    def total_price # TODO optimize for the phases
      price * (order_quantity || approved_quantity || desired_quantity)
    end

    #####################################################

    def self.csv_export(requests, current_user)
      require 'csv'

      objects = []
      requests.each do |request|
        objects << {
            _('Budget period') => request.budget_period,
            _('Procurement group') => request.group,
            _('Requester') => request.user,
            _('Model name') => request.model_description,
            _('Supplier') => request.supplier,
            _('Desired quantity') => request.desired_quantity,
            _('Approved quantity') => request.approved_quantity, # FIXME depending of inspection phase
            _('Order quantity') => request.order_quantity, # FIXME depending of inspection phase
            _('Price') => request.price,
            _('Total') => request.total_price,
            _('Status') => request.status(current_user),
            _('Priority') => request.priority,
            _('Receiver') => request.receiver,
            _('Organization unit') => request.organization_unit,
            _('Motivation') => request.motivation,
            _('Inspection comment') => request.inspection_comment # FIXME depending of inspection phase
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
