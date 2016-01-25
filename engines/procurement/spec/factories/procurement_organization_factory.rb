FactoryGirl.define do
  factory :procurement_organization, class: Procurement::Organization do
    name { Faker::Company.name }
    shortname { Faker::Company.suffix }

    trait :with_parent do
      before :create do |organization|
        organization.parent = FactoryGirl.create(:procurement_organization)
      end
    end
  end
end
