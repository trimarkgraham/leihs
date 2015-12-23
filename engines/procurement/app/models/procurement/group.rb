module Procurement
  class Group < ActiveRecord::Base

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :group_inspectors, dependent: :delete_all
    has_many :inspectors, through: :group_inspectors, source: :user

    has_many :requests, dependent: :restrict_with_exception
    has_many :template_categories, dependent: :delete_all
    has_many :templates, through: :template_categories

    has_many :budget_limits, dependent: :delete_all
    accepts_nested_attributes_for :budget_limits, allow_destroy: true, reject_if: proc { |attributes| attributes['amount'].to_i.zero? }

    def to_s
      name
    end

    def inspectable_by?(user)
      inspectors.include?(user)
    end

    def inspectable_or_readable_by?(user)
      Procurement::Group.inspector_of_any_group_or_admin?(user) or inspectable_by?(user)
    end

    class << self
      def inspector_of_any_group?(user)
        Procurement::GroupInspector.where(user_id: user).exists?
      end

      def inspector_of_any_group_or_admin?(user)
        inspector_of_any_group?(user) or Procurement::Access.is_admin?(user)
      end
    end

  end
end