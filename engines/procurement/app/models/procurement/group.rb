module Procurement
  class Group < ActiveRecord::Base

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :group_inspectors, dependent: :delete_all
    has_many :inspectors, through: :group_inspectors, source: :user

    has_many :requests, dependent: :restrict_with_exception
    has_many :request_templates, dependent: :delete_all

    has_many :budget_limits, dependent: :delete_all
    accepts_nested_attributes_for :budget_limits, allow_destroy: true

    def to_s
      name
    end

    def inspectable_by?(user)
      inspectors.include?(user)
    end

  end
end
