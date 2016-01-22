module NavigationSteps
  step 'I go to my requests' do
    visit procurement.overview_user_requests_path(@current_user)
  end
end

RSpec.configure { |c| c.include NavigationSteps }
