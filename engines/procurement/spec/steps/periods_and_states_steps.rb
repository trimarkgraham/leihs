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

  private

  def format_date(date)
    date.strftime '%d.%m.%Y'
  end
end

RSpec.configure { |c| c.include PeriodsAndStatesSteps }
