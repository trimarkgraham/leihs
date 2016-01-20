module SmokeTestSteps
  step 'it should work' do
    FactoryGirl.create :setting
    user = FactoryGirl.create(:user)
    user.access_rights << FactoryGirl.create(:access_right,
                                             role: :admin)
    FactoryGirl.create(:procurement_access,
                       user: user,
                       is_admin: true)

    FastGettext.locale = user.language.locale_name.gsub(/-/, '_')

    visit '/authenticator/db/login'
    fill_in _('Username'), with: user.login
    fill_in _('Password'), with: 'password'
    click_on 'Login'
    expect(page).to have_selector '.dropdown', text: user.short_name

    visit '/procurement'
    expect(page).to have_content _('Budget periods')

  end
end

RSpec.configure { |c| c.include SmokeTestSteps }
