# desc "Explaining what the task does"
# task :procurement do
#   # Task goes here
# end

namespace :procurement do
  desc 'Procurement data seed'
  task seed: :environment do

    { 'Services' => %w(ITZ FM PZ),
      'DKM' => ['Vertiefung Fotografie', 'Departementsleitung',
                'BA Arts in Medien und Kunst'],
      'DDK' => ['Departementsleitung', 'BA Film', 'BA Design'],
      'DDE' => ['Departementsleitung'],
      'DKV' => ['Departementsleitung', 'BA Art Education'],
      'DMU' => ['Departementsleitung', 'BA of Arts in Musik',
                'Betriebsleiter'] }.each_pair do |k, v|
      parent = Procurement::Organization.create name: k,
                                                shortname: nil,
                                                parent_id: nil
      v.each do |w|
        parent.children.create name: w, shortname: nil
      end
    end

    [1973, 5824, 601, 9103, 10558, 7329].each do |user_id|
      Procurement::Access.admins.create user_id: user_id
    end
    { 12 => ['Services', 'PZ'], 3881 => ['Services', 'PZ'],
      10 => ['Services', 'ITZ'], 1363 => ['DDK', 'BA Film'],
      667 => ['DKV', 'Departementsleitung'],
      4423 => ['DKM', 'Departementsleitung'],
      850 => ['DDE', 'Departementsleitung'],
      4491 => ['DDK', 'Departementsleitung'], 114 => ['Services', 'FM'],
      3848 => ['DMU', 'Betriebsleiter'], 9103 => ['Services', 'ITZ'],
      2415 => ['DMU', 'Departementsleitung'], 350 => ['Services', 'PZ'],
      422 => ['DKM', 'BA Arts in Medien und Kunst'], 5824 => ['Services', 'ITZ'],
      1260 => ['DKV', 'BA Art Education'],
      9069 => ['DMU', 'BA of Arts in Musik'],
      10558 => ['Services', 'ITZ'] }.each_pair do |user_id, organization_names|
      parent = Procurement::Organization.find_by(name: organization_names.first)
      organization = parent.children.find_by(name: organization_names.last)
      Procurement::Access.requesters.create user_id: user_id,
                                            organization: organization
    end

    { 'Werkstatt-Technik' => [12, 5824],
      'Produktionstechnik' => [3881, 5824],
      'AV' => [350, 5824],
      'Musikinstrumente' => [3848],
      'Facility Management' => [114],
      'IT' => [10, 5824] }.each_pair do |name, ids|
      Procurement::Group.create name: name, inspector_ids: ids
    end

    { 'Werkstatt-Technik' => 'adrian.brazerol@zhdk.ch',
      'AV' => 'mike.honegger@zhdk.ch',
      'Musikinstrumente' => 'dmu@zhdk.ch',
      'Facility Management' => 'fm@zhdk.ch',
      'IT' => 'it@zhdk.ch' }.each_pair do |name, email|
      Procurement::Group.find_by(name: name).update_attributes email: email
    end

    Procurement::BudgetPeriod.create name: '2017',
                                     inspection_start_date: '2016-10-01',
                                     end_date: '2016-11-01'
    Procurement::BudgetPeriod.create name: '2018',
                                     inspection_start_date: '2017-10-01',
                                     end_date: '2017-11-01'

    { 'Werkstatt-Technik' => { '2017' => 500000 },
      'AV' => { '2017' => 600000 },
      'Musikinstrumente' => { '2017' => 350000 },
      'Facility Management' => { '2017' => 350000 },
      'IT' => { '2017' => 500000 } }.each_pair do |name, budgets|
      group = Procurement::Group.find_by name: name
      budgets.each_pair do |budget_name, amount|
        budget_period = Procurement::BudgetPeriod.find_by name: budget_name
        group.budget_limits.create budget_period: budget_period, amount: amount
      end
    end

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 5824,
                                article_name: 'MacBook 13"',
                                requested_quantity: 10,
                                price: 1200,
                                supplier_name: 'Macshop',
                                priority: 'normal',
                                receiver: 'Becchio Silvan',
                                location_name: 'Toni-Areal',
                                motivation: 'meine Motivation'

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 5824,
                                article_name: 'Eizo 19 Zoll LCD Monitor M190020589 SCH',
                                requested_quantity: 1,
                                price: 550,
                                priority: 'normal',
                                receiver: 'Becchio Silvan',
                                location_name: 'Toni-Areal',
                                motivation: 'gleiche motivaton'

    Procurement::Request.create budget_period: Procurement::BudgetPeriod.find_by(name: '2017'),
                                group: Procurement::Group.find_by(name: 'IT'),
                                user_id: 5824,
                                article_name: 'MacBook 12" 2015',
                                requested_quantity: 5,
                                approved_quantity: 5,
                                order_quantity: 5,
                                price: 1000,
                                priority: 'normal',
                                inspection_comment: 'my motivation'

    [{ group_name: 'IT',
       name: 'Arbeitsplatz IT',
       templates: [{ article_name: 'It Arbeitsplätze',
                     price: 1200 }] },
     { group_name: 'IT',
       name: 'Bildschirme',
       templates: [{ article_name: 'Apple Cinema Display 20"',
                     price: 780 },
                   { article_name: 'Apple Cinema Display 23" oder 24"LED glossy',
                     price: 1100 },
                   { article_name: 'Quato Radon Intelli Proof 21, TFT Monitor, inkl. Silver Haze Pro',
                     price: 2990 }] },
     { group_name: 'IT',
       name: 'Computer',
       templates: [{ article_name: 'MacBook Intel C2 Duo 2.4GHz/13.3"/250GB/Superdrive/AP/BT mit 4096MB RAM',
                     price: 2100 },
                   { article_name: 'MacBook Pro Intel C2 Duo 2.53GHz/15.4"LED/320GB/Superdrive/AP/BT mit 4096MB RAM',
                     price: 2850 },
                   { article_name: 'iMac 24" Intel C2 Duo 2.8GHz/320GB/Superdrive/AP/BT mit 4096MB RAM',
                     price: 2200 }] },
     { group_name: 'IT',
       name: 'Digitalkameras',
       templates: [{ article_name: 'Canon IXUS 860IS, 8Megapixel, 3"-Monitor, 4x optischer Zoom, inkl. 8GB Speicherkarte',
                     price: 450 }] },
     { group_name: 'IT',
       name: 'Drucker',
       templates: [{ article_name: 'HP LaserJet 2015 A4, 32MB RAM, 26ppm, Duplex, 1200dpi, PCL5e, PCL6, PS2',
                     price: 680 },
                   { article_name: 'HP LaserJet 5200dtn, S/W, Duplex, A3, 1200 dpi x 1200 dpi, 35ppm, 10/100Base-TX',
                     price: 3500 }] },
     { group_name: 'IT',
       name: 'Eingabegeräte',
       templates: [{ article_name: 'Wacom intuos3 A4 regular USB Tablet mit Stift',
                     price: 480 }] },
     { group_name: 'IT',
       name: 'MitarbeiterInnen-Arbeitsplatz',
       templates: [{ article_name: 'Laptop: Lenovo Thinkpad X301 Intel C2 Duo 1.4GHz/64GB SSD/Wireless/BT mit 4096MB RAM',
                     price: 2300 }] },
     { group_name: 'IT',
       name: 'Scanner',
       templates: [{ article_name: 'Epson V500 Photo 6400 x 9600dpi, 48Bit, LED, Durchlicht bis Mittelformat',
                     price: 420,
                     supplier_name: 'DigitecZürich' }] },
     { group_name: 'IT',
       name: 'Software',
       templates: [{ article_name: 'Softwarepaket Design',
                     price: 200,
                     supplier_name: 'ITZ' }] }
    ].each do |x|
      tc = Procurement::TemplateCategory.create group: Procurement::Group.find_by(name: x[:group_name]),
                                                name: x[:name]
      x[:templates].each { |y| tc.templates.create y }
    end

    if Rails.env.development?
      Procurement::BudgetPeriod.create name: '2015',
                                       inspection_start_date: '2014-10-01',
                                       end_date: '2014-11-30'
      Procurement::BudgetPeriod.create name: '2016',
                                       inspection_start_date: '2015-10-01',
                                       end_date: '2015-11-30'

      user_id = 1973

      { user_id => ['Services', 'ITZ'] }.each_pair do |user_id, organization_names|
        parent = Procurement::Organization.find_by(name: organization_names.first)
        organization = parent.children.find_by(name: organization_names.last)
        Procurement::Access.requesters.create user_id: user_id,
                                              organization: organization
      end

      50.times do
        Procurement::Request.create budget_period: Procurement::BudgetPeriod.order('RAND()').first,
                                    group: Procurement::Group.order('RAND()').first,
                                    user_id: rand(0..1) == 0 ? user_id : Procurement::Access.requesters.order('RAND()').first.user_id,
                                    article_name: Faker::Lorem.sentence,
                                    requested_quantity: (requested_quantity = rand(1..120)),
                                    approved_quantity: (approved_quantity = rand(0..1) == 0 ? rand(1..requested_quantity) : nil),
                                    price: rand(10..5000),
                                    supplier_name: Faker::Lorem.sentence,
                                    priority: rand(0..1) == 1 ? 'high' : 'normal',
                                    motivation: Faker::Lorem.sentence,
                                    inspection_comment: approved_quantity ? Faker::Lorem.sentence : nil,
                                    receiver: Faker::Lorem.sentence,
                                    location_name: Faker::Lorem.sentence
      end

      { 'Facility Management' => [user_id],
        'IT' => [user_id] }.each_pair do |name, ids|
        group = Procurement::Group.find_by(name: name)
        group.inspectors << User.find(ids)
        group.save
      end

      Procurement::Group.all.each do |group|
        attrs = {}
        Procurement::BudgetPeriod.all.each do |bp|
          attrs[bp.id] = { budget_period_id: bp.id,
                           amount: rand(200000..1_200_000) }
        end
        group.update_attributes(budget_limits_attributes: attrs)
      end

    end

  end
end
