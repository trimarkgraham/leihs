FactoryGirl.define do
  factory :procurement_access, class: Procurement::Access do
    association :user

    trait :requester do
      before :create do |access|
        access.organization = FactoryGirl.create(:procurement_organization, :with_parent)
      end
    end

    trait :admin do
      before :create do |access|
        access.is_admin = true
      end
    end
  end
end
