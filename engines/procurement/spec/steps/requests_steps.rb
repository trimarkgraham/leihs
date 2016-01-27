require_relative 'helpers'
require_relative 'personas_steps'

steps_for :requests do
  include Helpers
  include PersonasSteps

  step 'the current date has not yet reached the inspection start date' do
    back_to_date Procurement::BudgetPeriod.current.inspection_start_date - 1.day
    expect(Time.zone.today).to be < \
      Procurement::BudgetPeriod.current.inspection_start_date
  end

  step 'I can delete my request' do
    request = get_current_request @current_user
    visit_request(request)

    within ".request[data-request_id='#{request.id}']" do
      find(".btn-group button.dropdown-toggle").click
      click_on _('Delete')
    end

    expect(page).to have_content _('Deleted')
    expect{request.reload}.to raise_error ActiveRecord::RecordNotFound
  end

  step 'I can modify my request' do
    request = get_current_request @current_user
    visit_request(request)

    within ".request[data-request_id='#{request.id}']" do
      fill_in _('Motivation'), with: "just text"
    end

    step 'I click on save'
    step 'I see a success message'
    expect(request.reload.motivation).to be == 'just text'
  end

  step 'I can change the budget period of my request' do
    request = get_current_request @current_user
    visit_request(request)
    next_budget_period = Procurement::BudgetPeriod. \
        where("end_date > ?", request.budget_period.end_date).first

    within ".request[data-request_id='#{request.id}']" do
      find(".btn-group button.dropdown-toggle").click
      click_on next_budget_period.name
    end

    expect(page).to have_content _('Request moved')
    expect(request.reload.budget_period_id).to be next_budget_period.id
  end

  private

  def get_current_request(user)
    Procurement::Request.find_by user_id: user.id,
                               budget_period_id: Procurement::BudgetPeriod.current
  end
end
