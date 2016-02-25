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

end

RSpec.configure { |c| c.include NavigationSteps }
