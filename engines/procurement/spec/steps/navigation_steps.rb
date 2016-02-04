module NavigationSteps
  step 'I navigate to the requests' do
    visit procurement.overview_requests_path
  end
  # TODO merge
  step 'I navigate to my requests' do
    step 'I navigate to the requests'
  end
  # TODO merge
  step 'I navigate to the inspection overview' do
    step 'I navigate to the requests'
  end

  step 'I navigate to the users list' do
    visit procurement.users_path
  end

  step 'I navigate to the organizations list' do
    visit procurement.organizations_path
  end

  step 'page has been loaded' do
    expect(has_no_selector?(".spinner")).to be true
  end

  step 'I enter the section :section' do |section|
    case section
      when 'My requests'
        step 'I navigate to my requests'
      else
        raise
    end
  end

  def visit_request(request)
    visit procurement.group_budget_period_user_requests_path(request.group,
                                                             request.budget_period,
                                                             request.user)
  end

  ############################################
  # TODO refactor to a CommonSteps module?

  step 'I click on save' do
    click_on _('Save')
  end

  step 'I see a success message' do
    expect(page).to have_content _('Saved')
  end

end

RSpec.configure { |c| c.include NavigationSteps }
