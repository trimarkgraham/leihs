module Procurement
  class Group < ActiveRecord::Base

    validates_presence_of :name

    has_many :group_accesses
    has_many :users, through: :group_accesses
    has_many :requesters, -> { where(procurement_group_accesses: {is_responsible: [nil, false]}) },
             through: :group_accesses,
             source: :user
    has_many :responsibles, -> { where(procurement_group_accesses: {is_responsible: true}) },
             through: :group_accesses,
             source: :user

    def to_s
      name
    end

  end
end
