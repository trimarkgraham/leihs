FactoryGirl.define do
  factory :procurement_request, class: Procurement::Request do
    user { FactoryGirl.create(:procurement_access, :requester).user }
    association :budget_period, factory: :procurement_budget_period
    association :group, factory: :procurement_group
    article_name { Faker::Lorem.sentence }
    motivation { Faker::Lorem.sentence }
    requested_quantity { 5 }
  end
end
