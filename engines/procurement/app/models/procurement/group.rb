module Procurement
  class Group < ActiveRecord::Base

    validates_presence_of :name

    has_many :group_inspectors
    has_many :inspectors, through: :group_inspectors, source: :user

    has_many :requests
    has_many :request_templates

    def to_s
      name
    end

    def inspectable_by?(user)
      inspectors.include?(user)
    end

  end
end
