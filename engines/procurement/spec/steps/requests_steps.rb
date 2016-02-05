require_relative 'helpers'
require_relative 'personas_steps'

steps_for :requests do
  include Helpers
  include PersonasSteps

  step 'the current date has not yet reached the inspection start date' do
    travel_to_date Procurement::BudgetPeriod.current.inspection_start_date - 1.day
    expect(Time.zone.today).to be < \
      Procurement::BudgetPeriod.current.inspection_start_date
  end

  step 'I can delete my request' do
    request = get_current_request @current_user
    visit_request(request)

    within ".request[data-request_id='#{request.id}']" do
      find(".btn-group button.dropdown-toggle").click
      click_on _('Delete')
    end

    expect(page).to have_content _('Deleted')
    expect{request.reload}.to raise_error ActiveRecord::RecordNotFound
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

  step 'I create a request' do
    step 'I navigate to my requests'
    within '.panel-success .panel-heading',
           text: Procurement::BudgetPeriod.current.name do
      find('i.fa-plus-circle').click
    end
    within '.panel-body .col-sm-6', text: _('Groups') do
      find('a', text: Procurement::Group.first.name).click
    end
    within '.panel-footer' do
      find('i.fa-plus-circle').click
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

  step 'the amount and the price are multiplied and the result is shown' do
    within '.request[data-request_id="new_request"]' do
      el = find '.label.label-primary.total_price'
      el.click # NOTE to trigger input change
      total = @price * @quantity
      expect(el.text).to eq \
       ActionController::Base.helpers.number_to_currency(
          total,
          unit: Setting.local_currency_string,
          precision: 0)
    end
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

  private

  def get_current_request(user)
    Procurement::Request.find_by user_id: user.id,
                               budget_period_id: Procurement::BudgetPeriod.current
  end
end
