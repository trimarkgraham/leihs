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

  step 'it should work with Gino' do
    step 'I am Gino'
    visit '/procurement'
    expect(page).to have_content _('Procurement')
  end

  step 'it should work with Barbara' do
    step 'I am Barbara'
    visit '/procurement'
    binding.pry
    expect(page).to have_content _('Procurement')
  end
end

RSpec.configure { |c| c.include SmokeTestSteps }
