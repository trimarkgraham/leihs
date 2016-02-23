FactoryGirl.define do
  factory :procurement_request, class: Procurement::Request do
    user { FactoryGirl.create(:procurement_access, :requester).user }

    # association :budget_period, factory: :procurement_budget_period
    budget_period { Procurement::BudgetPeriod.current ||
                    FactoryGirl.create(:procurement_budget_period) }

    # association :group, factory: :procurement_group
    group { Procurement::Group.first || FactoryGirl.create(:procurement_group) }

    article_name { Faker::Lorem.sentence }
    motivation { Faker::Lorem.sentence }
    price { 123 }
    requested_quantity { 5 }
    approved_quantity { nil }
  end
end
