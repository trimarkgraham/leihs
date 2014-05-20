require 'rubygems'
require 'pry'

# require 'simplecov'
# SimpleCov.start 'rails' do
#   merge_timeout 3600
# end

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'cucumber/rails'
require 'rack_session_access/capybara'

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# screenshot
require 'capybara-screenshot/cucumber'
Capybara::Screenshot.autosave_on_failure = false # FIXME capybara-screenshot could not detect a screenshot driver for 'selenium_phantomjs' and 'selenium_firefox'. Saving with default with unknown results.

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how 
# your application behaves in the production environment, where an error page will 
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

##################################################################################

require 'selenium/webdriver'

Capybara.register_driver :selenium_phantomjs do |app|
  Capybara::Selenium::Driver.new app, browser: :phantomjs #, capabilities: {a: 1}
end

Capybara.register_driver :selenium_firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  # we need a firefox extension to start intercepting javascript errors before the page scripts load
  # see https://github.com/mguillem/JSErrorCollector
  profile.add_extension File.join(Rails.root, "features/support/extensions/JSErrorCollector.xpi")
  Capybara::Selenium::Driver.new app, :profile => profile
end

##################################################################################

begin
  # we cannot use transactional tests because we are restoring personas data from sql dumps
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Before('@javascript', '~@firefox') do
  Capybara.current_driver = :selenium_phantomjs
end

Before('@javascript', '@firefox') do
  Capybara.current_driver = :selenium_firefox
  page.driver.browser.manage.window.maximize # to prevent Selenium::WebDriver::Error::MoveTargetOutOfBoundsError: Element cannot be scrolled into view
end

Before do
  Persona.use_test_random_date
  Cucumber.logger.info "Current capybara driver: %s\n" % Capybara.current_driver
  DatabaseCleaner.clean_with :truncation
end

##################################################################################

After('@javascript', '@firefox') do
  if page.driver.to_s.match("Selenium")
    errors = page.execute_script("return window.JSErrorCollector_errors.pump()")

    if errors.any?
      puts '-------------------------------------------------------------'
      puts "Found #{errors.length} javascript errors"
      puts '-------------------------------------------------------------'
      errors.each do |error|
        puts "    #{error["errorMessage"]} (#{error["sourceName"]}:#{error["lineNumber"]})"
      end
      # Raise an error here if you want JS errors to make your Capybara test count as failed
      #raise "Javascript errors detected, see above"
    end
  end
end

if ENV["PRY"]
  AfterStep do
    binding.pry
  end
end

##################################################################################

