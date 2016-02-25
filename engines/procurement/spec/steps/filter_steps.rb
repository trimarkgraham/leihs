module FilterSteps

  step 'all groups in the filter groups are selected' do
    within '#filter_panel' do
      within 'select[name="filter[group_ids][]"]', visible: false do
        Procurement::Group.all.each do |group|
          expect(find "option[value='#{group.id}']", visible: false).to \
            be_selected
        end
      end
    end
  end

  step 'all organisations are selected' do
    within '#filter_panel .form-group', text: _('Organisations') do
      within '.btn-group' do
        find 'button', text: _('All')
      end
    end
  end

  step 'I do not see the filter "only show my own requests"' do
    within '#filter_panel' do
      expect(has_no_selector? 'input[name="user_id"]').to be true
      expect(has_no_selector? 'div',
                              text: _('Only show my own requests')).to be true
    end
  end

  step 'I select a specific organisation' do
    selected_organization = Procurement::Organization.where(parent_id: nil).first
    within '#filter_panel .form-group', text: _('Organisations') do
      within '.btn-group' do
        find('button.multiselect').click
        choose selected_organization.name
        find('button.multiselect').click
      end
    end
  end

  step 'I select all :string_with_spaces' do |string_with_spaces|
    text = case string_with_spaces
             when 'groups'
               _('Groups')
             when 'budget periods'
               _('Budget periods')
             else
               raise
           end
    within '#filter_panel .form-group', text: text do
      within '.btn-group' do
        find('button.multiselect').click
        # all(:checkbox).each { |x| x.set true }
        check _('Select all')
        find('button.multiselect').click
      end
    end
  end

  step 'I select one or more :string_with_spaces' do |string_with_spaces|
    text = case string_with_spaces
             when 'groups'
               _('Groups')
             when 'budget periods'
               _('Budget periods')
             else
               raise
           end
    within '#filter_panel .form-group', text: text do
      within '.btn-group' do
        find('button.multiselect').click
        all(:checkbox).sample(2).each { |x| x.set true }
        find('button.multiselect').click
      end
    end
  end

  step 'the current budget period is selected' do
    budget_period = Procurement::BudgetPeriod.current
    within '#filter_panel' do
      within 'select[name="filter[budget_period_ids][]"]', visible: false do
        expect(find "option[value='#{budget_period.id}']", visible: false).to \
          be_selected
      end
    end
  end

end

RSpec.configure { |c| c.include FilterSteps }
