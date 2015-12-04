# desc "Explaining what the task does"
# task :procurement do
#   # Task goes here
# end

namespace :procurement do
  desc 'Procurement data seed'
  task seed: :environment do

    {'Services' => ['ITZ'],
     'DKM' => ['Vertiefung Fotografie']}.each_pair do |k,v|
      parent = Procurement::Organization.create name: k, shortname: nil, parent_id: nil
      v.each do |w|
        parent.children.create name: w, shortname: nil
      end
    end

    [1973, 5824, 601].each do |id|
      Procurement::Access.admins.create user_id: id
    end
    [1973, 5824, 12, 350, 3848].each do |id|
      Procurement::Access.requesters.create user_id: id, organization: Procurement::Organization.where.not(parent_id: nil).order('RAND()').first
    end

    {'Werkstatt-Technik' => [12, 5824],
     'Produktionstechnik' => [3881, 5824],
     'AV' => [350, 5824],
     'Musikinstrumente' => [3848],
     'Facility Management' => [114],
     'IT' => [10, 5824]}.each_pair do |name, ids|
      Procurement::Group.create name: name, inspector_ids: ids
    end

    {'Werkstatt-Technik' => 'adrian.brazerol@zhdk.ch',
     'AV' => 'mike.honegger@zhdk.ch',
     'Musikinstrumente' => 'dmu@zhdk.ch',
     'Facility Management' => 'fm@zhdk.ch',
     'IT' => 'it@zhdk.ch'}.each_pair do |name, email|
      Procurement::Group.find_by(name: name).update_attributes email: email
    end

    Procurement::BudgetPeriod.create name: '2017', inspection_start_date: '2016-10-01', end_date: '2016-11-01'
    Procurement::BudgetPeriod.create name: '2018', inspection_start_date: '2017-10-01', end_date: '2017-11-01'

    {'Werkstatt-Technik' => {'2017' => 500000},
     'AV' => {'2017' => 600000},
     'Musikinstrumente' => {'2017' => 350000},
     'Facility Management' => {'2017' => 350000},
     'IT' => {'2017' => 500000}}.each_pair do |name, budgets|
      group = Procurement::Group.find_by name: name
      budgets.each_pair do |budget_name, amount|
        budget_period = Procurement::BudgetPeriod.find_by name: budget_name
        group.budget_limits.create budget_period: budget_period, amount: amount
      end
    end

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 5824,
                                model_description: 'MacBook 13"',
                                requested_quantity: 10,
                                price: 1200,
                                supplier: 'Macshop',
                                priority: 'normal',
                                receiver: 'Becchio Silvan',
                                location: 'Toni-Areal',
                                motivation: 'meine Motivation'

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 5824,
                                model_description: 'Eizo 19 Zoll LCD Monitor M190020589 SCH',
                                requested_quantity: 1,
                                price: 550,
                                priority: 'normal',
                                receiver: 'Becchio Silvan',
                                location: 'Toni-Areal',
                                motivation: 'gleiche motivaton'

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 1973,
                                model_description: 'MacBook 12" 2015',
                                requested_quantity: 5,
                                approved_quantity: 5,
                                order_quantity: 5,
                                price: 1000,
                                priority: 'normal',
                                inspection_comment: 'my motivation'

    c1 = Procurement::TemplateCategory.create group: Procurement::Group.find_by(name: 'IT'),
                                              name: 'Laptops'

    Procurement::Template.create template_category: c1,
                                 model_description: "Netzteil Apple Macbook MagSafe 2",
                                 price: 200

    Procurement::Template.create template_category: c1,
                                 model_description: 'MacBook 15"',
                                 price: 2000

    if Rails.env.development?
      Procurement::BudgetPeriod.create name: '2015', inspection_start_date: '2014-10-01', end_date: '2014-11-30'
      Procurement::BudgetPeriod.create name: '2016', inspection_start_date: '2015-10-01', end_date: '2015-11-30'

      user_id = 1973

      50.times do
        Procurement::Request.create budget_period: Procurement::BudgetPeriod.order('RAND()').first,
                                    group: Procurement::Group.order('RAND()').first,
                                    user_id: rand(0..1) == 0 ? user_id : Procurement::Access.requesters.order('RAND()').first.user_id,
                                    model_description: Faker::Lorem.sentence,
                                    requested_quantity: (requested_quantity = rand(1..120)),
                                    approved_quantity: (approved_quantity = rand(0..1) == 0 ? rand(1..requested_quantity) : nil),
                                    price: rand(10..5000),
                                    supplier: Faker::Lorem.sentence,
                                    priority: rand(0..1) == 1 ? 'high' : 'normal',
                                    motivation: Faker::Lorem.sentence,
                                    inspection_comment: approved_quantity ? Faker::Lorem.sentence : nil,
                                    receiver: Faker::Lorem.sentence,
                                    location: Faker::Lorem.sentence
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
