require_relative 'personas_steps'

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
    line.find("input[name*='department']").set Faker::Lorem.word
  end

  step 'I fill in the organization' do
    line = find('form table tbody tr')
    line.find("input[name*='organization']").set Faker::Lorem.word
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
    FactoryGirl.create(:procurement_access, :requester, user: @user)
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
    expect(first('form table tbody tr td:first-child input', text: @user.name))
      .not_to be
  end

  step 'the requester was successfully deleted from the database' do
    expect(Procurement::Access.find_by_user_id(@user.id)).not_to be
  end

  step 'I modify the requester name to be that of the extra user' do
    line = find_requester_line(@user.name)
    line.find("input[name*='name']").set(@extra_user.name)
    find('.ui-autocomplete .ui-menu-item a').click
  end

  step 'I modify the department' do
    line = find_requester_line(@user.name)
    @new_department = Faker::Lorem.word
    line.find("input[name*='department']").set @new_department
  end

  step 'I modify the organization' do
    line = find_requester_line(@user.name)
    @new_organization = Faker::Lorem.word
    line.find("input[name*='organization']").set @new_organization
  end

  step 'there exists an extra user' do
    @extra_user = create_user(Faker::Name.first_name)
  end

  step 'I see the successful changes on the page' do
    expect { find_requester_line(@user.name) }
      .to raise_error Capybara::ElementNotFound
    line = find_requester_line(@extra_user.name)
    expect(line.find("input[name*='department']").value)
      .to be == @new_department
    expect(line.find("input[name*='organization']").value)
      .to be == @new_organization
  end

  step 'the requester information was changed successfully in the database' do
    expect(Procurement::Access.find_by_user_id(@user.id)).not_to be
    access = Procurement::Access.find_by_user_id(@extra_user.id)
    expect(access.organization.name).to be == @new_organization
    dep = Procurement::Organization.find_by_name(@new_department)
    expect(dep).to be
    expect(dep.children).to \
      include Procurement::Organization.find_by_name(@new_organization)
  end

  step 'I can add an admin' do
    step 'I go to the users list'
    admin_ids = Procurement::Access.admins.pluck(:user_id)
    user = User.not_as_delegations.where.not(id: admin_ids).order('RAND()').first \
            || FactoryGirl.create(:user)
    find('.token-input-list .token-input-input-token input#token-input-').set user.name
    find('.token-input-dropdown li', text: user.name).click
    step 'I click on save'
    expect(Procurement::Access.admins.exists?(user.id)).to be true
  end

  step 'the admins are sorted alphabetically from a-z' do
    texts = all('.token-input-list .token-input-token').map &:text
    expect(texts).to be == texts.sort
    expect(texts.count).to be Procurement::Access.admins.count
  end

  step 'I can delete an admin' do
    step 'I go to the users list'
    user = Procurement::Access.admins.order('RAND()').first.user
    find('.token-input-list .token-input-token', text: user.name) \
      .find('.token-input-delete-token').click
    step 'I click on save'
    expect(Procurement::Access.admins.exists?(user.id)).to be false
  end

  step 'I can view the organisation tree according to the organisations assigned to requester' do
    step 'there exist 10 requesters'
    step 'I go to the organizations list'
    pending
    # Procurement::Access.requesters.each do |requester|
    #   find('li', text: requester.user.name).find(:xpath, "ancestor::li")
    # end
  end

  private

  def find_requester_line(name)
    find(:xpath, "//input[@value='#{name}']/ancestor::tr")
  end
end

RSpec.configure do |c|
  c.include UsersAndOrganisationsSteps, users_and_organisations: true
end
