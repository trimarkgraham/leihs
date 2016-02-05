require_relative 'personas_steps'

steps_for :roles do
  include PersonasSteps

  step 'there exists a request' do
    FactoryGirl.create(:procurement_request)
  end

  step 'I can manage my requests' do
    within 'header' do
      click_on _('Requests')
    end
  end
end
