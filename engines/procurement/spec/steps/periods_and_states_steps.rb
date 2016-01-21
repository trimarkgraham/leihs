require_relative "personas_steps"

module PeriodsAndStatesSteps
  include PersonasSteps

  step 'there does not exist any budget period yet' do
    expect(Procurement::BudgetPeriod.count).to be == 0
  end

  step 'I navigate to the budget periods' do
    within '.navbar' do
      click_on _('Admin')
      click_on _('Budget periods')
    end
    expect(page).to have_selector('h1', text: _('Budget periods'))
  end

  step 'there is an empty budget period line for creating a new one' do
    line = find('table tbody tr')
    line.all('input').each { |i| expect(i.value).to be_blank }
  end

  step 'I fill in the name' do
    line = find('form table tbody tr')
    line.find("input[name*='name']").set Date.today.year + 1
  end

  step 'I fill in the start date of the inspection period' do
    line = find('form table tbody tr')
    line.find("input[name*='inspection_start_date']").set format_date(Date.today + 1)
  end

  step 'I fill in the end date of the inspection period' do
    line = find('form table tbody tr')
    line.find("input[name*='end_date']").set format_date(Date.today + 1.month)
  end

  step 'I click on save' do
    click_on _('Save')
  end

  step 'I see a success message' do
    expect(page).to have_content _('Saved')
  end

  step 'budget periods exist' do
    current_year = Date.today.year
    @budget_periods = []
    (1..3).each do |num|
      @budget_periods << \
        FactoryGirl.create(:procurement_budget_period,
                           name: current_year + num,
                           inspection_start_date: Date.new(current_year + num, 1, 1),
                           end_date: Date.new(current_year + num, 1, 2))
    end
  end

  step 'the budget periods are sorted from 0-10 and a-z' do
    names = all('form table tbody tr td:first-child input').map(&:value)
    expect(names).to be == @budget_periods.map(&:name).sort
  end

  step 'a budget period without any requests exists' do
    @budget_period = FactoryGirl.create(:procurement_budget_period)
    expect(@budget_period.requests).to be_empty
  end

  step 'I click on \'delete\' on the line for this budget period' do
    accept_alert do
      find('form table tbody tr td:first-child input', exact: @budget_period.name)
        .find(:xpath, '../..')
        .click_on _('Delete')
    end
  end

  step 'this budget period disappears from the list' do
    expect(first('form table tbody tr td:first-child input', text: @budget_period.name)).not_to be
  end

  step 'this budget period was deleted from the database' do
    expect(Procurement::BudgetPeriod.find_by_id(@budget_period.id)).not_to be
  end

  step 'I choose a budget period to edit' do
    @budget_period = Procurement::BudgetPeriod.first
  end

  step 'I change the name of the budget period' do
    budget_period_line = find_budget_period_line_by_name(@budget_period.name)
    @new_name = 'New name'
    budget_period_line.find("input[name*='name']").set @new_name
  end

  step 'I change the inspection start date of the budget period' do
    budget_period_line = find_budget_period_line_by_name(@budget_period.name)
    @new_inspection_start_date = Date.today + 5.month
    budget_period_line.find("input[name*='inspection_start_date']").set format_date(@new_inspection_start_date)
  end

  step 'I change the end date of the budget period' do
    budget_period_line = find_budget_period_line_by_name(@budget_period.name)
    @new_end_date = Date.today + 6.month
    budget_period_line.find("input[name*='end_date']").set format_date(@new_end_date)
  end

  step 'the budget period line was updated successfully' do
    within find_budget_period_line_by_name(@new_name) do
      expect(find("input[name*='name']").value).to be == @new_name
      expect(find("input[name*='inspection_start_date']").value).to be == format_date(@new_inspection_start_date)
      expect(find("input[name*='end_date']").value).to be == format_date(@new_end_date)
    end
  end

  step 'the data for the budget period was updated successfully in the database' do
    @budget_period.reload
    expect(@budget_period.name).to be == @new_name
    expect(@budget_period.inspection_start_date).to be == @new_inspection_start_date
    expect(@budget_period.end_date).to be == @new_end_date
  end

  private

  def find_budget_period_line_by_name(name)
    find("form table tbody tr input[value='#{name}']")
      .find(:xpath, '../..')
  end

  def format_date(date)
    date.strftime '%d.%m.%Y'
  end
end

RSpec.configure { |c| c.include PeriodsAndStatesSteps }
