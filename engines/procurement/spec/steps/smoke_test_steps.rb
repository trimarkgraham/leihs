module SmokeTestSteps
  step 'it should work' do
    visit '/procurement'
  end
end

RSpec.configure { |c| c.include SmokeTestSteps }
