require_relative 'helpers'

steps_for :managing_requests do
  include Helpers

  step 'a request exists created by myself' do
    @request = FactoryGirl.create(:procurement_request, user: @current_user)
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

  step 'I do not see the filter "only show my own requests"' do
    within '#filter_panel' do
      expect(has_no_selector? 'input[name="user_id"]').to be true
      expect(has_no_selector? 'div',
                              text: _('Only show my own requests')).to be true
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

  step 'I see the amount of requests which are listed is :n' do |n|
    within '#filter_target' do
      find 'h4', text: /^#{n} #{_('Requests')}$/
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

  step 'I see the current budget period' do
    find '.panel-success .panel-heading .h4',
         text: Procurement::BudgetPeriod.current.name
  end

  step 'I see the headers of the colums of the overview' do
    find '#column-titles'
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

  step 'I see the requested amount per budget period' do
    find '.panel-success .panel-heading .label-primary.big_total_price',
         text: Procurement::BudgetPeriod.current.requests \
                .where(user_id: @current_user) \
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

  step 'I see the total of all ordered amounts of a budget period' do
    find '.panel-success .panel-heading .label-primary.big_total_price',
         text: Procurement::BudgetPeriod.current.requests \
                .map {|r| r.total_price(@current_user) }.sum
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

  step 'I can change the budget period of my request' do
    request = get_current_request @current_user
    visit_request(request)
    next_budget_period = Procurement::BudgetPeriod. \
        where("end_date > ?", request.budget_period.end_date).first

    within ".request[data-request_id='#{request.id}']" do
      find(".btn-group button.dropdown-toggle").click
      click_on next_budget_period.name
    end

    expect(page).to have_content _('Request moved')
    expect(request.reload.budget_period_id).to be next_budget_period.id
  end

  step 'I can change the procurement group of my request' do
    request = get_current_request @current_user
    visit_request(request)
    other_group = Procurement::Group.where.not(id: request.group_id).first

    within ".request[data-request_id='#{request.id}']" do
      find(".btn-group button.dropdown-toggle").click
      click_on other_group.name
    end

    expect(page).to have_content _('Request moved')
    expect(request.reload.group_id).to be other_group.id
  end

  step 'I can choose the following :field values' do |field, table|
    within '.request[data-request_id="new_request"]' do
      label = case field
                when 'priority'
                  _('Priority')
                when 'replacement'
                  "%s / %s" % [_('Replacement'), _('New')]
                else
                  raise
              end
      within '.form-group', text: label do
        table.raw.flatten.each do |value|
          choose _(value)
        end
      end
    end
  end

  step 'I can delete my request' do
    @request = get_current_request @current_user
    visit_request(@request)

    step 'I delete the request'

    expect(page).to have_content _('Deleted')
    expect{@request.reload}.to raise_error ActiveRecord::RecordNotFound
  end

  step 'I can modify my request' do
    request = get_current_request @current_user
    visit_request(request)

    text = Faker::Lorem.sentence
    within ".request[data-request_id='#{request.id}']" do
      fill_in _('Motivation'), with: text
    end

    step 'I click on save'
    step 'I see a success message'
    expect(request.reload.motivation).to eq text
  end

  step 'I click on :choice' do |choice|
    case choice
      when 'yes'
        page.driver.browser.switch_to.alert.accept
      when 'no'
        page.driver.browser.switch_to.alert.dismiss
      else
        raise
    end
  end

  step 'I create a request' do
    step 'I navigate to the requests page'
    within '.panel-success .panel-heading',
           text: Procurement::BudgetPeriod.current.name do
      find('i.fa-plus-circle').click
    end
    within '.panel-body .col-sm-6', text: _('Create request for specific group') do
      find('a', text: Procurement::Group.first.name).click
    end
    within '.sidebar-wrapper' do
      find('i.fa-plus-circle').click
    end
  end

  step 'I delete the request' do
    within ".request[data-request_id='#{@request.id}']" do
      find(".btn-group button.dropdown-toggle").click
      click_on _('Delete')
    end
  end

  step 'I enter the requested amount' do
    within '.request[data-request_id="new_request"]' do
      @price = Faker::Number.number(4).to_i
      @quantity = Faker::Number.number(2).to_i
      within '.form-group', text: _('Item price') do
        find('input').set @price
      end
      fill_in _('Requested quantity'), with: @quantity
    end
  end

  step 'I open the request' do
    find(".list-group-item[data-request_id='#{@request.id}']").click
  end

  step 'I receive a message asking me if I am sure I want to delete the data' do
    # page.driver.browser.switch_to.alert.accept
  end

  step 'no requests exist' do
    Procurement::Request.destroy_all
    expect(Procurement::Request.count).to be_zero
  end

  step 'the amount and the price are multiplied and the result is shown' do
    within '.request[data-request_id="new_request"]' do
      el = find '.label.label-primary.total_price'
      total = @price * @quantity
      expect(el.text).to eq \
       ActionController::Base.helpers.number_to_currency(
          total,
          unit: Setting.local_currency_string,
          precision: 0)
    end
  end

  step 'the current date has not yet reached the inspection start date' do
    travel_to_date Procurement::BudgetPeriod.current.inspection_start_date - 1.day
    expect(Time.zone.today).to be < \
      Procurement::BudgetPeriod.current.inspection_start_date
  end

  step 'the :field value :value is set by default' do |field, value|
    within '.request[data-request_id="new_request"]' do
      label = case field
                when 'priority'
                  _('Priority')
                when 'replacement'
                  "%s / %s" % [_('Replacement'), _('New')]
                else
                  raise
              end
      within '.form-group', text: label do
        within 'label', text: /^#{_(value)}$/ do
          find("input[type='radio']:checked")
        end
      end
    end
  end

  private

  def get_current_request(user)
    Procurement::Request.find_by user_id: user.id,
                                 budget_period_id: Procurement::BudgetPeriod.current
  end

end
