require_relative 'personas_steps'

steps_for :procurement_groups do
  include PersonasSteps

  step 'I navigate to the groups page' do
    within '.navbar' do
      click_on _('Admin')
      click_on _('Groups')
    end
    expect(page).to have_selector('h1', text: _('Groups'))
  end

  step 'I click on the add button' do
    click_on _('Add')
  end

  step 'there exists :count users to become the inspectors' do |count|
    @inspectors = []
    count.to_i.times do
      @inspectors << create_user(Faker::Name.first_name)
    end
  end

  step 'I fill in the name' do
    @name = Faker::Lorem.word
    find("input[name='group[name]']").set @name
  end

  step 'I fill in the inspectors\' names' do
    @inspectors.each do |inspector|
      find('.row', text: _('Inspectors')).find('input').set inspector.name
      find('.token-input-dropdown', text: inspector.name).click
    end
  end

  step 'I fill in the email' do
    @email = Faker::Internet.email
    find("input[name='group[email]']").set @email
  end

  step 'I fill in the budget limit' do
    @limit = 1000
    find('.row', text: @budget_period.name)
      .find("input[name*='amount']")
      .set @limit
  end

  step 'a budget period exist' do
    @budget_period = FactoryGirl.create(:procurement_budget_period)
  end

  step 'I click on save' do
    click_on _('Save')
  end

  step 'I am redirected to the groups index page' do
    expect(current_path).to be == '/procurement/groups'
  end

  step 'the new group appears in the list' do
    find('table').find('tr', text: @name)
  end

  step 'the new group was created in the database' do
    group = Procurement::Group.find_by_name(@name)
    expect(group).to be
    expect(group.name).to be == @name
    expect(group.email).to be == @email
    @inspectors.each do |inspector|
      expect(group.inspectors).to include inspector
    end
    expect(group.budget_limits.first.amount_cents).to be == (@limit * 100)
  end

  step ':count procurement groups exist' do |count|
    @groups = []
    count.to_i.times do
      @groups << FactoryGirl.create(:procurement_group)
    end
  end

  step 'the procurement groups are sorted alphabetically' do
    names = all('table tbody tr td:first-child').map(&:text)
    expect(names).to be == @groups.map(&:name).sort
  end

  step 'there exists a procurement group' do
    @group = FactoryGirl.create(:procurement_group)
  end

  step 'there exists :count budget limits for the procurement group' do |count|
    @group.budget_limits.delete_all
    count.to_i.times do
      @group.budget_limits << FactoryGirl.create(:procurement_budget_limit)
    end
  end

  step 'the procurement group has :count inspectors' do |count|
    @group.inspectors.delete_all
    count.to_i.times do
      @group.inspectors << create_user(Faker::Name.first_name)
    end
  end
end
