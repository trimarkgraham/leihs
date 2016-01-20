FactoryGirl.define do
  factory :procurement_group, class: Procurement::Group do
    name { Faker::Commerce.department }
    email { Faker::Internet.email }
  end
end
