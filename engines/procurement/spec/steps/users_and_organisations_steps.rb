require_relative "personas_steps"

module UsersAndOrganisationsSteps
  include PersonasSteps

  step 'I navigate to the users page' do
    within '.navbar' do
      click_on _('Admin')
      click_on _('Users')
    end
    expect(page).to have_selector('h1', text: _('Users'))
  end

  step 'there does not exist any requester yet' do
    expect(Procurement::Access.requesters.count).to be == 0
  end

  step 'there is an empty requester line for creating a new one' do
    line = find('table tbody tr')
    line.all('input').each { |i| expect(i.value).to be_blank }
  end

  step 'there exists a user to become a requester' do
    @user = create_user(Faker::Name.first_name)
  end

  step 'I fill in the requester name' do
    line = find('table tbody tr')
    line.find("input[name*='name']").set(@user.name)
    find('.ui-autocomplete .ui-menu-item a').click
  end

  step 'I fill in the department' do
    line = find('form table tbody tr')
    line.find("input[name*='department']").set Faker::Commerce.department
  end

  step 'I fill in the organization' do
    line = find('form table tbody tr')
    line.find("input[name*='organization']").set Faker::Commerce.department
  end

  step 'the new requester was created in the database' do
    requester = Procurement::Access.requesters.find_by_user_id @user.id
    expect(requester).to be
  end

  step 'the :field is marked red' do |field|
    line = find('form table tbody tr')
    input_field = case field
                  when 'requester name'
                    line.find("input[name*='name']")
                  when 'department'
                    line.find("input[name*='department']")
                  when 'organization'
                    line.find("input[name*='organization']")
                  end
    expect(input_field['required']).to be == 'true' # ;-)
  end

  step 'the new requester has not been created' do
    requester = Procurement::Access.requesters.find_by_user_id @user.id
    expect(requester).not_to be
  end

  step 'there exists a requester' do
    @user = create_user(Faker::Name.first_name)
    FactoryGirl.create(:procurement_access, user_id: @user.id)
  end

  step 'I click on the minus button on the requester line' do
    find('form table tbody tr td:first-child input', exact: @user.name)
      .find(:xpath, '../..')
      .find('.fa-minus-circle')
      .click
  end

  step 'the requester line is marked for deletion' do
    find('form table tbody tr.bg-danger td:first-child input', exact: @user.name)
  end

  step 'the requester disappears from the list' do
    expect(first('form table tbody tr td:first-child input', text: @user.name)).not_to be
  end

  step 'the requester was successfully deleted from the database' do
    expect(Procurement::Access.find_by_user_id(@user.id)).not_to be
  end
end

RSpec.configure { |c| c.include UsersAndOrganisationsSteps }