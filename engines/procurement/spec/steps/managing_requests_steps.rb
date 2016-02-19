steps_for :managing_requests do

  step 'no requests exist' do
    Procurement::Request.destroy_all
    expect(Procurement::Request.count).to be_zero
  end

  step 'I see the headers of the colums of the overview' do
    find '#column-titles'
  end

  step 'I see the amount of requests which are listed is :n' do |n|
    within '#filter_target' do
      find 'h4', text: /^#{n} #{_('Requests')}$/
    end
  end

  step 'I see the current budget period' do
    find '.panel-success .panel-heading .h4',
         text: Procurement::BudgetPeriod.current.name
  end

  step 'I see the requested amount per budget period' do
    find '.panel-success .panel-heading .label-primary.big_total_price',
         text: Procurement::BudgetPeriod.current.requests \
                .where(user_id: @current_user) \
                .map {|r| r.total_price(@current_user) }.sum
  end

  step 'I see the total of all ordered amounts of a budget period' do
    find '.panel-success .panel-heading .label-primary.big_total_price',
         text: Procurement::BudgetPeriod.current.requests \
                .map {|r| r.total_price(@current_user) }.sum
  end

  step 'I see the requested amount per group of each budget period' do
    within '.panel-success .panel-body' do
      Procurement::Group.all.each do |group|
        within '.row', text: group.name do
          find '.label-primary.big_total_price',
               text: Procurement::BudgetPeriod.current.requests \
                      .where(user_id: @current_user) \
                      .where(group_id: group) \
                      .map {|r| r.total_price(@current_user) }.sum
        end
      end
    end
  end

  step 'I see the total of all ordered amounts of each groups' do
    within '.panel-success .panel-body' do
      Procurement::Group.all.each do |group|
        within '.row', text: group.name do
          find '.label-primary.big_total_price',
               text: Procurement::BudgetPeriod.current.requests \
                      .where(group_id: group) \
                      .map {|r| r.total_price(@current_user) }.sum
        end
      end
    end
  end

  step 'I see the budget limits of all groups' do
    within '.panel-success .panel-body' do
      Procurement::Group.all.each do |group|
        within '.row', text: group.name do
          amount = group.budget_limits \
                    .find_by(budget_period_id: Procurement::BudgetPeriod.current) \
                    .try(:amount) || 0
          find '.budget_limit',
               text: amount
        end
      end
    end
  end

  step 'I do not see the budget limits' do
    within '.panel-success .panel-body' do
      Procurement::Group.all.each do |group|
        within '.row', text: group.name do
          expect(has_no_selector? '.budget_limit').to be true
        end
      end
    end
  end

  step 'I see the percentage of budget used ' \
       'compared to the budget limit of my group' do
    within '.panel-success .panel-body' do
      Procurement::Group.all.each do |group|
        within '.row', text: group.name do
          amount = group.budget_limits \
                    .find_by(budget_period_id: Procurement::BudgetPeriod.current) \
                    .try(:amount) || 0
          used = Procurement::BudgetPeriod.current.requests \
                      .where(group_id: group) \
                      .map {|r| r.total_price(@current_user) }.sum
          percentage = if amount > 0
                         used * 100 / amount
                       elsif used > 0
                         100
                       else
                         0
                       end
          find '.progress-radial',
               text: '%d%' % percentage
        end
      end
    end
  end

  step 'I do not see the percentage signs' do
    within '.panel-success .panel-body' do
      Procurement::Group.all.each do |group|
        within '.row', text: group.name do
          expect(has_no_selector? '.progress-radial').to be true
        end
      end
    end
  end

  step 'I see when the requesting phase of this budget period ends' do
    within '.panel-success .panel-heading' do
      find '.row',
           text: _('requesting phase until %s') \
                  % I18n.l(Procurement::BudgetPeriod.current.inspection_start_date)
    end
  end

  step 'I see when the inspection phase of this budget period ends' do
    within '.panel-success .panel-heading' do
      find '.row',
           text: _('inspection phase until %s') \
                  % I18n.l(Procurement::BudgetPeriod.current.end_date)
    end
  end

  step 'I do not see the filter "only show my own requests"' do
    within '#filter_panel' do
      expect(has_no_selector? 'input[name="user_id"]').to be true
      expect(has_no_selector? 'div',
                              text: _('Only show my own requests')).to be true
    end
  end
end
