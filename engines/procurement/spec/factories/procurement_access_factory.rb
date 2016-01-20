FactoryGirl.define do
  factory :procurement_access, class: Procurement::Access do
    association :user
    organization { FactoryGirl.create(:procurement_organization) unless is_admin }
    is_admin false
  end
end
