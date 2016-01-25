module NavigationSteps
  step 'I go to my requests' do
    visit procurement.overview_user_requests_path(@current_user)
  end

  step 'I go to the inspection overview' do
    visit procurement.overview_requests_path
  end

  def visit_request(request)
    visit procurement.group_budget_period_user_requests_path(request.group,
                                                             request.budget_period,
                                                             request.user)
  end
end

RSpec.configure { |c| c.include NavigationSteps }
