module SmokeTestSteps
  step 'it should work' do
    binding.pry
    visit '/procurement'
  end
end

RSpec.configure { |c| c.include SmokeTestSteps }
