module Procurement
  class Group < ActiveRecord::Base

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :group_inspectors, dependent: :delete_all
    has_many :inspectors, through: :group_inspectors, source: :user

    has_many :requests, dependent: :restrict_with_exception
    has_many :request_templates, dependent: :delete_all

    def to_s
      name
    end

    def inspectable_by?(user)
      inspectors.include?(user)
    end

  end
end
