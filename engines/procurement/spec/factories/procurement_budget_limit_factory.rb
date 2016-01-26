FactoryGirl.define do
  factory :procurement_budget_limit, class: Procurement::BudgetLimit do
    association :group, factory: :procurement_group
    association :budget_period, factory: :procurement_budget_period
    amount_cents 100000
    amount_currency 'USD'
  end
end
