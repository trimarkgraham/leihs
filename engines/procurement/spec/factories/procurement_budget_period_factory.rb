FactoryGirl.define do
  factory :procurement_budget_period, class: Procurement::BudgetPeriod do
    name { Date.today.year }
    inspection_start_date { Date.today + 1.month }
    end_date { Date.today + 2.month }
  end
end
