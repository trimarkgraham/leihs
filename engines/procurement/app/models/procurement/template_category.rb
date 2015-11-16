module Procurement
  class TemplateCategory < ActiveRecord::Base

    belongs_to :group
    has_many :templates
    accepts_nested_attributes_for :templates, allow_destroy: true, reject_if: :all_blank

    validates_uniqueness_of :name, scope: :group_id

    def to_s
      name
    end

  end
end
