FactoryGirl.define do
  factory :procurement_request, class: Procurement::Request do
    user { r = Procurement::Access.requesters.order('RAND()').first \
                || FactoryGirl.create(:procurement_access)
           r.user
          }
    association :budget_period, factory: :procurement_budget_period
    association :group, factory: :procurement_group
    article_name { Faker::Lorem.sentence }
    motivation { Faker::Lorem.sentence }
    requested_quantity { rand(0..20) }
  end
end
