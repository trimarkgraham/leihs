# desc "Explaining what the task does"
# task :procurement do
#   # Task goes here
# end

namespace :procurement do
  desc 'Procurement data seed'
  task seed: :environment do
    [1973, 5824, 601].each do |id|
      Procurement::Access.admins.create user_id: id
    end
    [1973, 5824].each do |id|
      Procurement::Access.requesters.create user_id: id
    end

    {'Werkstatt-Technik' => [12],
     'Produktionstechnik' => [3881],
     'AV' => [350, 5824],
     'Musikinstrumente' => [3848],
     'Facility Management' => [114],
     'IT' => [10, 5824]}.each_pair do |name, ids|
      Procurement::Group.create name: name, inspector_ids: ids
    end

    Procurement::BudgetPeriod.create name: '2017', inspection_start_date: '2016-10-01', end_date: '2016-11-01'
    Procurement::BudgetPeriod.create name: '2018', inspection_start_date: '2017-10-01', end_date: '2017-11-01'

    o1 = Procurement::Organization.create name: 'Services', shortname: nil, parent_id: nil
    Procurement::Organization.create name: 'ITZ', shortname: nil, parent: o1

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 5824,
                                model_description: 'MacBook 13"',
                                desired_quantity: 10,
                                price: 1200,
                                supplier: 'Macshop',
                                priority: 'medium',
                                receiver: 'Becchio Silvan',
                                organization_unit: 'Finanzen',
                                motivation: 'meine Motivation'

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 5824,
                                model_description: 'Eizo 19 Zoll LCD Monitor M190020589 SCH',
                                desired_quantity: 1,
                                price: 550,
                                priority: 'medium',
                                receiver: 'Becchio Silvan',
                                organization_unit: 'Finanzen',
                                motivation: 'gleiche motivaton'

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 1973,
                                model_description: 'MacBook 12" 2015',
                                desired_quantity: 5,
                                approved_quantity: 5,
                                order_quantity: 5,
                                price: 1000,
                                priority: 'medium',
                                inspection_comment: 'my motivation'

    Procurement::RequestTemplate.create group: Procurement::Group.find_by(name: 'IT'),
                                        model_description: "Netzteil Apple Macbook MagSafe 2",
                                        price: 200

    if Rails.env.development?
      Procurement::BudgetPeriod.create name: '2015', inspection_start_date: '2014-10-01', end_date: '2014-11-30'
      Procurement::BudgetPeriod.create name: '2016', inspection_start_date: '2015-10-01', end_date: '2015-11-30'

      user_id = 1973

      50.times do
        Procurement::Request.create budget_period: Procurement::BudgetPeriod.order('RAND()').first,
                                    group: Procurement::Group.order('RAND()').first,
                                    user_id: rand(0..1) == 0 ? user_id : Procurement::Access.requesters.order('RAND()').first.user_id,
                                    model_description: Faker::Lorem.sentence,
                                    desired_quantity: (desired_quantity = rand(1..120)),
                                    approved_quantity: (approved_quantity = rand(0..1) == 0 ? rand(1..desired_quantity) : nil),
                                    price: rand(10..5000),
                                    supplier: Faker::Lorem.sentence,
                                    priority: rand(0..1) == 1 ? 'high' : 'medium',
                                    motivation: Faker::Lorem.sentence,
                                    inspection_comment: approved_quantity ? Faker::Lorem.sentence : nil,
                                    receiver: Faker::Lorem.sentence,
                                    organization_unit: Faker::Lorem.sentence
      end

      {'Facility Management' => [user_id],
       'IT' => [user_id]}.each_pair do |name, ids|
        group = Procurement::Group.find_by(name: name)
        group.inspectors << User.find(ids)
        group.save
      end

      Procurement::Group.all.each do |group|
        attrs = {}
        Procurement::BudgetPeriod.all.each {|bp| attrs[bp.id] = {budget_period_id: bp.id, amount: rand(200000..1200000)} }
        group.update_attributes(budget_limits_attributes: attrs)
      end

    end

  end
end
