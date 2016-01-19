module SmokeTestSteps
  step 'it should work' do
    user = FactoryGirl.create(:user)
    user.access_rights << FactoryGirl.create(:access_right,
                                             role: :admin)
    FactoryGirl.create(:procurement_access,
                       user: user,
                       is_admin: true)

    visit '/authenticator/db/login'
    fill_in 'Benutzername', with: user.login
    fill_in 'Passwort', with: 'password'
    click_on 'Login'
    expect(page).to have_selector '.dropdown', text: user.short_name

    visit '/procurement'
    expect(page).to have_content 'Budget Perioden'

  end
end

RSpec.configure { |c| c.include SmokeTestSteps }
