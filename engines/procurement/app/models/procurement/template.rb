module Procurement
  class Template < ActiveRecord::Base

    belongs_to :template_category
    belongs_to :model     # from parent application
    belongs_to :supplier  # from parent application
    has_many :requests, dependent: :nullify

    monetize :price_cents

    validates_presence_of :article_name

    def to_s
      article_name
    end

  end
end
