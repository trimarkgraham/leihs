module Procurement
  class Access < ActiveRecord::Base

    belongs_to :user
    belongs_to :organization

    has_many :requests, foreign_key: :user_id, primary_key: :user_id

    validates_presence_of :user
    validates_presence_of :organization, unless: Proc.new {|r| r.is_admin }
    validates_uniqueness_of :user, scope: :is_admin

    scope :requesters, -> { where(is_admin: [nil, false]) }
    scope :admins, -> { where(is_admin: true) }

  end
end
