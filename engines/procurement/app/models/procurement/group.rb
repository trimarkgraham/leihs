module Procurement
  class Group < ActiveRecord::Base

    validates_presence_of :name

    has_many :group_responsibles
    has_many :responsibles, through: :group_responsibles, source: :user

    has_many :requests
    has_many :request_templates

    def to_s
      name
    end

  end
end
