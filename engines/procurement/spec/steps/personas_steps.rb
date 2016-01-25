module PersonasSteps
  # procurement admin
  step 'I am Hans Ueli' do
    persona = create_persona('Hans Ueli')
    FactoryGirl.create(:procurement_access,
                       user: persona,
                       is_admin: true)
    login_as persona
    visit '/procurement'
  end

  # requester
  step 'I am Roger' do
    persona = create_persona('Roger')
    Procurement::Access.requesters.create(user: persona,
                                          organization: FactoryGirl.create(:procurement_organization, :with_parent))
    login_as persona
    visit '/procurement'
  end

  # inspector
  step 'I am Barbara' do
    persona = create_persona('Barbara')
    FactoryGirl.create(:procurement_group_inspector,
                       user: persona)
    login_as persona
    visit '/procurement'
  end

  # leihs admin
  step 'I am Gino' do
    persona = create_persona('Gino')
    FactoryGirl.create(:access_right, role: :admin)
    login_as persona
    visit '/procurement'
  end

  step 'a procurement admin exists' do
    Procurement::Access.admins.exists? \
      || FactoryGirl.create(:procurement_access, is_admin: true)
  end

  def create_user(firstname)
    user = FactoryGirl.create(:user, firstname: firstname)
    FactoryGirl.create(:access_right,
                       user: user,
                       inventory_pool: FactoryGirl.create(:inventory_pool))
    user
  end

  private

  def set_locale(user)
    FastGettext.locale = user.language.locale_name.gsub(/-/, '_')
  end

  def create_persona(firstname)
    user = create_user(firstname)
    set_locale(user)
    user
  end

  def login_as(user)
    @current_user = user
    visit '/authenticator/db/login'
    fill_in _('Username'), with: user.login
    fill_in _('Password'), with: 'password'
    click_on 'Login'
    expect(page).to have_content user.short_name
  end
end

RSpec.configure { |c| c.include PersonasSteps }
