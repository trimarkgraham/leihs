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
    find("input[name='group[name]']").set Faker::Lorem.word
  end

  step 'I fill in the inspectors\' names' do
    @inspectors.each do |inspector|
      find('.row', text: _('Inspectors')).find('input').set inspector.name
      find('.token-input-dropdown', text: inspector.name).click
    end
  end

  step 'I fill in the email' do
    find("input[name='group[email]']").set Faker::Internet.email
  end

  step 'I fill in the budget limit' do
    binding.pry
  end

  private

  # def find_requester_line(name)
  #   find(:xpath, "//input[@value='#{name}']/ancestor::tr")
  # end
end
