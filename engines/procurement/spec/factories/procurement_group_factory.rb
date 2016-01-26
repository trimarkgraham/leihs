FactoryGirl.define do
  factory :procurement_group, class: Procurement::Group do
    name { Faker::Lorem.word }
    email { Faker::Internet.email }
  end
end
