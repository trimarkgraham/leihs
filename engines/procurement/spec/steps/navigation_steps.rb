module NavigationSteps
  step 'I go to my requests' do
    visit procurement.overview_user_requests_path(@current_user)
  end

  step 'I go to the inspection overview' do
    visit procurement.overview_requests_path
  end
end

RSpec.configure { |c| c.include NavigationSteps }
