module DatasetSteps

  step 'the basic dataset is ready' do
    step 'a procurement admin exists'
    step 'the current budget period exist'
  end

end

RSpec.configure { |c| c.include DatasetSteps }
