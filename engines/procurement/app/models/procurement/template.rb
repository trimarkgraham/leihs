module Procurement
  class Template < ActiveRecord::Base

    belongs_to :template_category

    monetize :price_cents

    validates_presence_of :model_description

    def to_s
      "%s - %s %s" % [model_description, price.currency, price.to_i]
    end

  end
end
