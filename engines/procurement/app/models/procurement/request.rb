module Procurement
  class Request < ActiveRecord::Base

    belongs_to :budget_period
    belongs_to :group
    belongs_to :organization
    belongs_to :user      # from parent application
    belongs_to :model     # from parent application
    belongs_to :supplier  # from parent application
    belongs_to :location  # from parent application

    has_many :attachments, dependent: :destroy, inverse_of: :request
    accepts_nested_attributes_for :attachments

    monetize :price_cents, allow_nil: true

    before_validation do
      self.price ||= 0

      self.order_quantity ||= approved_quantity
      self.approved_quantity ||= order_quantity

      self.organization_id ||= Access.requesters.find_by(user_id: user_id).organization_id
    end

    validates_presence_of :user, :organization, :article_name, :motivation
    validates_presence_of :inspection_comment, if: proc { |r| r.approved_quantity and r.approved_quantity < r.requested_quantity }
    validates :requested_quantity, presence: true, numericality: { greater_than: 0 }

    #################################################################

    def editable?(user)
      Access.requesters.find_by(user_id: user_id) and
          (
            (budget_period.in_requesting_phase? \
              and (user_id == user.id or group.inspectable_by?(user))) \
            or
            (budget_period.in_inspection_phase? and group.inspectable_by?(user))
          )
    end

    STATES = [:new, :in_inspection, :denied, :partially_approved, :approved]

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
      quantity = if (not budget_period.in_requesting_phase?) \
                      or group.inspectable_or_readable_by?(current_user)
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
        show_all = (not request.budget_period.in_requesting_phase?) \
                      or request.group.inspectable_or_readable_by?(current_user)
        objects << {
          _('Budget period') => request.budget_period,
          _('Group') => request.group,
          _('Requester') => request.user,
          _('Article') => request.article_name,
          _('Article nr. / Producer nr.') => request.article_number,
          _('Supplier') => request.supplier_name,
          _('Requested quantity') => request.requested_quantity,
          _('Approved quantity') => (show_all ? request.approved_quantity : nil),
          _('Order quantity') => (show_all ? request.order_quantity : nil),
          ('%s %s' % [_('Price'), _('incl. VAT')]) => request.price,
          ('%s %s' % [_('Total'), _('incl. VAT')]) => request.total_price(current_user),
          _('State') => _(request.state(current_user).to_s.humanize),
          _('Priority') => request.priority,
          _('Article nr. / Producer nr.') => request.article_number,
          '%s / %s' % [_('Replacement'), _('New')] => (request.replacement ? _('Replacement') : _('New')),
          _('Point of Delivery') => request.location_name,
          _('Motivation') => request.motivation,
          _('Inspection comment') => (show_all ? request.inspection_comment : nil)
        }
      end

      csv_header = objects.flat_map(&:keys).uniq

      CSV.generate(col_sep: ';',
                   quote_char: "\"",
                   force_quotes: true,
                   headers: :first_row) do |csv|
        csv << csv_header
        objects.each do |object|
          csv << csv_header.map { |h| object[h] }
        end
      end
    end

  end
end
