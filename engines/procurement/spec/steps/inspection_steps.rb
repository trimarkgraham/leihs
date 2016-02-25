steps_for :inspection do

  step 'I see both my requests' do
    within '#filter_target' do
      Procurement::Request.where(user_id: @current_user).pluck(:id).each do |id|
        find "[data-request_id='#{id}']"
      end
    end
  end

  step 'following requests exist for the current budget period' do |table|
    current_budget_period = Procurement::BudgetPeriod.current
    table.hashes.each do |value|
      n = value['quantity'].to_i
      user = case value['user']
               when 'myself' then @current_user
               else
                 User.find_by(firstname: value['user']) || \
               begin
                   new_user = create_user(value['user'])
                   FactoryGirl.create :procurement_access,
                                      :requester,
                                      user: new_user
                   new_user
                 end
             end
      n.times do
        FactoryGirl.create :procurement_request,
                           user: user,
                           budget_period: current_budget_period
      end
      expect(current_budget_period.requests.where(user_id: user).count).to eq n
    end
  end

  step 'several requests exist' do
    n = 3
    n.times do
      FactoryGirl.create :procurement_request
    end
    expect(Procurement::Request.count).to eq n
  end

  step 'templates for my group exist' do
    @group = Procurement::Group.all.detect do |group|
      group.inspectable_by?(@current_user)
    end
    3.times do
      FactoryGirl.create :procurement_template_category,
                         :with_templates,
                         group: @group
    end
  end

  step 'the list of requests is adjusted immediately' do
    within '#filter_target' do
      expect(has_no_selector? '.spinner').to be true
    end
  end

end
