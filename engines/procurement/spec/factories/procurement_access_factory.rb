FactoryGirl.define do
  factory :procurement_access, class: Procurement::Access do
    association :user
    # association :procurement_organization, class: Procurement::Organization
    is_admin { false }
  end
end
