module SmokeTestSteps
  step 'it should work' do
    visit '/procurement'
    binding.pry
  end
end

RSpec.configure { |c| c.include SmokeTestSteps }
