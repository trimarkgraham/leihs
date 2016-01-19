require 'pry'
require 'turnip/capybara'
require 'rails_helper'
require 'factory_girl'
require 'database_cleaner'

Dir.glob("engines/procurement/spec/steps/**/*steps.rb") { |f| load f, true }
Dir.glob("engines/procurement/spec/factories/**/*factory.rb") { |f| load f, true }

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new app, browser: :firefox
end

RSpec.configure do |config|

  DatabaseCleaner.strategy = :truncation

  config.before(type: :feature) do
    DatabaseCleaner.start
  end

  config.after(type: :feature) do
    DatabaseCleaner.clean
  end

  config.before(browser: true) do
    Capybara.current_driver = :selenium_firefox
  end

  config.after(browser: true) do
    Capybara.current_driver = Capybara.default_driver
  end

end
