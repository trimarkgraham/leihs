FactoryGirl.define do
  factory :procurement_organization, class: Procurement::Organization do
    name { Faker::Company.name }
    shortname { Faker::Company.suffix }

    trait :with_parent do
      after :create do |organization|
        organization.update_attributes parent: FactoryGirl.create(:procurement_organization)
      end
    end
  end
end
