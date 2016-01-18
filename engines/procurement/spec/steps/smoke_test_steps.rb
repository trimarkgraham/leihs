module SmokeTestSteps
  step 'it should work' do
    true
  end
end

RSpec.configure { |c| c.include SmokeTestSteps }
