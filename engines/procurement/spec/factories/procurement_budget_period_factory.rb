FactoryGirl.define do
  factory :procurement_budget_period, class: Procurement::BudgetPeriod do
    name { Faker::Lorem.word }
    inspection_start_date { Date.today + 1.month }
    end_date { Date.today + 2.month }
  end
end
