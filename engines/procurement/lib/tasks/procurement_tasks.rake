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

    if Rails.env.development?
      Procurement::BudgetPeriod.create name: '2015', inspection_start_date: '2014-10-01', end_date: '2014-11-30'
      Procurement::BudgetPeriod.create name: '2016', inspection_start_date: '2015-10-01', end_date: '2015-11-30'

      user_id = 1973

      50.times do
        created_at = rand((Time.now - 2.years)..Time.now)
        Procurement::Request.create group: Procurement::Group.order('RAND()').first,
                                    user_id: rand(0..1) == 0 ? user_id : Procurement::Access.requesters.order('RAND()').first.user_id,
                                    model_description: Faker::Lorem.sentence,
                                    desired_quantity: (desired_quantity = rand(1..50)),
                                    approved_quantity: (approved_quantity = created_at < (Time.now - 2.weeks) ? rand(1..desired_quantity) : nil),
                                    price: rand(10..1000),
                                    supplier: Faker::Lorem.sentence,
                                    priority: rand(0..1) == 1 ? 'high' : 'medium',
                                    motivation: Faker::Lorem.sentence,
                                    inspection_comment: approved_quantity ? Faker::Lorem.sentence : nil,
                                    receiver: Faker::Lorem.sentence,
                                    organization_unit: Faker::Lorem.sentence,
                                    created_at: created_at
      end

      {'Facility Management' => [user_id],
       'IT' => [user_id]}.each_pair do |name, ids|
        group = Procurement::Group.find_by(name: name)
        group.inspectors << User.find(ids)
        group.save
      end
    end

  end
end
