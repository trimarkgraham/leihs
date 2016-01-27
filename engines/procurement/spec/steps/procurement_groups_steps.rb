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
      add_to_inspectors_field inspector.name
    end
  end

  step 'I fill in the email' do
    @email = Faker::Internet.email
    find("input[name='group[email]']").set @email
  end

  step 'I fill in the budget limit' do
    @limit = 1000
    set_budget_limit @budget_period.name, @limit
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

  step 'I navigate to the group\'s edit page' do
    visit procurement.edit_group_path(@group)
  end

  step 'I modify the name' do
    @new_name = Faker::Lorem.word
    find("input[name='group[name]']").set @new_name
  end

  step 'I delete an inspector' do
    @deleted_inspector = @group.inspectors.first
    find('.row', text: _('Inspectors'))
      .find('.token-input-token', text: @deleted_inspector.name)
      .find('.token-input-delete-token')
      .click
  end

  step 'I add an inspector' do
    @new_inspector = create_user(Faker::Name.first_name)
    add_to_inspectors_field @new_inspector.name
  end

  step 'I modify the email address' do
    @new_email = Faker::Internet.email
    find("input[name='group[email]']").set @new_email
  end

  step 'I delete a budget limit' do
    @delete_limit = @group.budget_limits.first
    set_budget_limit @delete_limit.budget_period.name, 0
  end

  step 'I add a budget limit' do
    @new_limit = 2000
    set_budget_limit @extra_budget_period.name, @new_limit
  end

  step 'I modify a budget limit' do
    @modified_limit = 3000
    set_budget_limit @group.budget_limits.last.budget_period.name,
                     @modified_limit
  end

  step 'there exists an extra budget period' do
    @extra_budget_period = FactoryGirl.create(:procurement_budget_period)
  end

  step 'I see that the all the information of the procurement group was updated correctly' do
  end

  private

  def add_to_inspectors_field(name)
    find('.row', text: _('Inspectors')).find('input').set name
    find('.token-input-dropdown', text: name).click
  end

  def set_budget_limit(name, limit)
    find('.row', text: name)
      .find("input[name*='amount']")
      .set limit
  end
end
