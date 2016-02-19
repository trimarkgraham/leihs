module NavigationSteps
  step 'I navigate to the requests page' do
    visit procurement.overview_requests_path
  end

  step 'I navigate to the requests overview page' do
    step 'I navigate to the requests page'
  end

  # step 'I navigate to the users list' do
  #   visit procurement.users_path
  # end
  step 'I navigate to the users page' do
    within '.navbar' do
      click_on _('Admin')
      click_on _('Users')
    end
    expect(page).to have_selector('h1', text: _('Users'))
  end

  step 'I navigate to the organisation tree page' do
    within '.navbar' do
      click_on _('Admin')
      click_on _('Organisations')
    end
    expect(page).to have_selector('h1', text: _('Organisations of the requesters'))
  end

  step 'I navigate to the templates page' do
    within '.navbar' do
      click_on _('Templates')
      click_on @group.name
    end
    expect(page).to have_selector('h1', text: _('Templates'))
  end

  step 'page has been loaded' do
    expect(has_no_selector?(".spinner")).to be true
  end

  step 'I enter the section :section' do |section|
    case section
      when 'My requests'
        step 'I navigate to the requests page'
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
    click_on _('Save'), match: :first
  end

  step 'I see a success message' do
    #expect(page).to have_content _('Saved')
    find '.flash .alert-success', match: :first
  end

  step 'I select all :string_with_spaces' do |string_with_spaces|
    text = case string_with_spaces
             when 'groups'
               _('Groups')
             when 'budget periods'
               _('Budget periods')
             else
               raise
           end
    within find('.form-group', text: text).find('.btn-group') do
      find('button.multiselect').click
      all(:checkbox).each { |x| x.set true }
      find('button.multiselect').click
    end
  end

  step 'the current budget period exist' do
    FactoryGirl.create(:procurement_budget_period)
  end

end

RSpec.configure { |c| c.include NavigationSteps }
