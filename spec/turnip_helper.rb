require 'turnip/capybara'
require 'rails_helper'

Dir.glob("engines/procurement/spec/steps/**/*steps.rb") { |f| load f, true }

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new app, browser: :firefox
end

RSpec.configure do |config|
  config.before(browser: true) do
    Capybara.current_driver = :selenium_firefox
  end
  config.after(browser: true) do
    Capybara.current_driver = Capybara.default_driver
  end
end
