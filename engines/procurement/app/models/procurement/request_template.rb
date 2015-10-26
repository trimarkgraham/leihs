module Procurement
  class RequestTemplate < ActiveRecord::Base

    belongs_to :user
    belongs_to :group

    monetize :price_cents

    validates_presence_of :description

  end
end
