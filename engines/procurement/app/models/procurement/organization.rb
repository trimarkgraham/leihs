module Procurement
  class Organization < ActiveRecord::Base
    extend ActsAsTree::TreeWalker

    acts_as_tree #order: "name"

    validates_presence_of :name

    belongs_to :parent, class_name: 'Organization'
    has_many :children, class_name: 'Organization', foreign_key: :parent_id

    # scope :roots, -> { where(parent_id: nil) }

    def to_s
      name
    end

  end
end
