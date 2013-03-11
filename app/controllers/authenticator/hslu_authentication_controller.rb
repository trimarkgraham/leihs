#require 'net/ldap'
require 'net/ldap'

class LdapHelper
  def initialize
    @base_dn = LDAP_CONFIG[Rails.env]["base_dn"]
    @search_field = LDAP_CONFIG[Rails.env]["search_field"]
    @host = LDAP_CONFIG[Rails.env]["host"]
    @port = LDAP_CONFIG[Rails.env]["port"].to_i || 636
    @encryption = LDAP_CONFIG[Rails.env]["encryption"].to_sym || :simple_tls
    @method = :simple
    @master_bind_dn = LDAP_CONFIG[Rails.env]["master_bind_dn"]
    @master_bind_pw = LDAP_CONFIG[Rails.env]["master_bind_pw"]
    raise "'master_bind_dn' and 'master_bind_pw' must be set in LDAP configuration file" if (@master_bind_dn.blank? or @master_bind_pw.blank?)
  end

  def bind(username = @master_bind_dn, password = @master_bind_pw)
    ldap = Net::LDAP.new :host => @host,
    :port => @port, 
    :encryption => @encryption,
    :base => @base_dn,
    :auth => {
      :method=> @method,
      :username => username,
      :password => password 
    }
    if ldap.bind
      return ldap
    else
      logger = Rails.logger
      logger.error "Can't bind to LDAP server #{@host} as user '#{username}'. Wrong bind credentials or encryption parameters?"
      return false
    end
  end
end


class Authenticator::HsluAuthenticationController < Authenticator::AuthenticatorController

  $general_layout_path = 'layouts/backend/' + $theme + '/general'
  layout $general_layout_path
  def login_form_path
    "/authenticator/hslu/login"
  end

  # @param login [String] The login of the user you want to create
  # @param email [String] The email address of the user you want to create
  def create_user(login, email)
    user = User.new(:login => login, :email => "#{email}")
    if user.save
      # Assign any default roles you want
      role = Role.find_by_name("customer")
      InventoryPool.all.each do |ip|
        user.access_rights.create(:inventory_pool_id => ip, :role => role)
      end
      return user
    else
      logger = Rails.logger
      logger.error "Could not create user with login #{login}: #{user.errors.full_messages}"
      return false
    end
  end

  # @param user [User] The (local, database) user whose data you want to update
  # @param user_data [Net::LDAP::Entry] The LDAP entry (it could also just be a hash of hashes and arrays that looks like a Net::LDAP::Entry) of that user
  def update_user(user, user_data)
    user.firstname = user_data["givenname"].to_s 
    user.lastname = user_data["sn"].to_s
    user.phone = user_data["telephonenumber"].to_s unless user_data["telephonenumber"].blank?
    user.badge_id = "I" + user_data["extensionattribute6"].to_s unless user_data["extensionattribute6"].blank?
    user.address = user_data["streetaddress"].to_s

    preferred_language = user_data["msexchuserculture"].to_s
    if preferred_language == 1 or !(preferred_language =~ /^de/).nil? 
      language = Language.find(:first, :conditions => ["locale_name LIKE 'de%' AND active = ?", true])
    elsif preferred_language == 2 or !(preferred_language =~ /^en/).nil? 
      language = Language.find(:first, :conditions => ["locale_name LIKE 'en%' AND active = ?", true])
    else
      language = Language.default_language
    end
    user.language = language if language

    # This does not conform to the specification from "Login und Benutzerdaten leihs", where only
    # "streetAddress" was specified. A standard AD server schema will split the address up nicely, 
    # as shown below. I think this is better than randomly trying to split the address from a single
    # string.
    user.address = user_data["streetaddress"].to_s
    user.city = user_data["l"].to_s
    user.country = user_data["c"].to_s
    user.zip = user_data["postalcode"].to_s

    # Make sure to set USER_IMAGE_URL in application.rb in leihs 3.0 for user images to appear, based
    # on the unique ID. Example for the format in application.rb:
    # http://www.hslu.ch/portrait/{:id}.jpg
    # {:id} will be interpolated with user.unique_id there.
    user.unique_id = user_data["pager"].to_s

    admin_dn = LDAP_CONFIG[Rails.env]["admin_dn"]
    unless admin_dn.blank?
      if user_data["memberof"].include?(admin_dn)
        admin_role = Role.find_by_name("admin")
        user.access_rights.create(:role => admin_role) unless user.access_rights.include?(admin_role)
      end
    end
  end
  
  def login
    if request.post?
      user = params[:login][:user]
      password = params[:login][:password]
      if user == "" || password == ""
        flash[:notice] = _("Empty Username and/or Password")
      else
        ldaphelper = LdapHelper.new
        begin
          ldap = ldaphelper.bind

          if ldap
            users = ldap.search(:base => LDAP_CONFIG[Rails.env]["base"], :filter => Net::LDAP::Filter.eq(LDAP_CONFIG[Rails.env]["search_field"], "#{user}"))

            if users.size == 1
              email = users.first.mail if users.first.mail
              email ||= "#{user}@hslu.ch"
              bind_dn = users.first.dn
              ldaphelper = LdapHelper.new
              if ldaphelper.bind(bind_dn, password)
                u = User.find_by_login(user)
                if not u
                  u = create_user(user, email)
                end

                if not u == false
                  update_user(u, users.first)
                  u.save
                  self.current_user = u
                  redirect_back_or_default("/")
                  return true
                else
                  flash[:notice] = _("Could not create new user for '#{user}' from LDAP source. Contact your leihs system administrator.")
                end
              else
                flash[:notice] = _("Invalid username/password")
              end
            else
              flash[:notice] = _("User unknown") if users.size == 0
              flash[:notice] = _("Too many users found") if users.size > 0
            end
          else
            flash[:notice] = _("Invalid technical user - contact your leihs admin")
            redirect_to :action => 'login'
          end
        rescue Net::LDAP::LdapError
          flash[:notice] = _("Couldn't connect to LDAP: #{LDAP_CONFIG[:host]}:#{LDAP_CONFIG[:port]}")
        end
      end
    end
  end  
end