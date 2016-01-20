require 'pry'
require 'turnip/capybara'
require 'rails_helper'
require 'factory_girl'

Dir.glob("engines/procurement/spec/steps/**/*steps.rb") { |f| load f, true }
Dir.glob("engines/procurement/spec/factories/**/*factory.rb") { |f| load f, true }

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new app, browser: :firefox
end

RSpec.configure do |config|

  unless ENV['CIDER_CI_TRIAL_ID'].present?
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)

    config.before(type: :feature) do
      DatabaseCleaner.start
    end

    config.after(type: :feature) do
      DatabaseCleaner.clean
    end
  end

  config.before(type: :feature) do
    FactoryGirl.create(:setting) unless Setting.first
  end

  config.before(browser: true) do
    Capybara.current_driver = :selenium_firefox
  end

  config.after(browser: true) do
    Capybara.current_driver = Capybara.default_driver
  end

end
