module NavigationSteps

  step 'I navigate to the requests page' do
    # visit procurement.overview_requests_path
    within '.navbar' do
      click_on _('Requests')
    end
    expect(page).to have_selector('h4', text: _('Requests'))
  end
  # alias
  step 'I navigate back to the request overview page' do
    step 'I navigate to the requests page'
  end
  # alias
  step 'I navigate to the requests overview page' do
    step 'I navigate to the requests page'
  end

  step 'I navigate to the budget periods' do
    within '.navbar' do
      click_on _('Admin')
      click_on _('Budget periods')
    end
    expect(page).to have_selector('h1', text: _('Budget periods'))
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

  step 'I navigate to the templates page of my group' do
    within '.navbar' do
      click_on _('Templates')
      click_on @group.name
    end
    expect(page).to have_selector('h1', text: _('Templates'))
  end
  # alias
  step 'I navigate to the templates page' do
    step 'I navigate to the templates page of my group'
  end

end

RSpec.configure { |c| c.include NavigationSteps }
