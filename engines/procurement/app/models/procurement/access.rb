module Procurement
  class Access < ActiveRecord::Base

    belongs_to :user

    validates_presence_of :user

    scope :requesters, -> { where(is_admin: [nil, false]) }
    scope :admins, -> { where(is_admin: true) }

  end
end
