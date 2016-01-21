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

  private

  def format_date(date)
    date.strftime '%d.%m.%Y'
  end
end

RSpec.configure { |c| c.include PeriodsAndStatesSteps }
