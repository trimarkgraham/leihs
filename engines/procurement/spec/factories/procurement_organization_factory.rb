FactoryGirl.define do
  factory :procurement_organization, class: Procurement::Organization do
    name { Faker::Company.name }
    shortname { Faker::Company.suffix }
  end
end
