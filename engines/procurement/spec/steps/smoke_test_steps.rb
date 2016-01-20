require_relative "personas_steps"

module SmokeTestSteps
  include PersonasSteps

  step 'it should work with Roger' do
    step 'I am Roger'
    visit '/procurement'
    expect(page).to have_content _('Procurement')
  end

  step 'it should work with Hans Ueli' do
    step 'I am Hans Ueli'
    visit '/procurement'
    expect(page).to have_content _('Procurement')
  end
end

RSpec.configure { |c| c.include SmokeTestSteps }
