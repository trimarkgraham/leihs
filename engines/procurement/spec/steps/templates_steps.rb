steps_for :templates do

  step 'I navigate to edit templates of an inspectable group' do
    @group = Procurement::Group.all.detect {|g| g.inspectable_by?(@current_user) }
    FactoryGirl.create :procurement_template_category,
                       :with_templates,
                       group: @group
    expect(@group.templates).to be_exists
    visit procurement.group_templates_path(@group)
  end

  step 'I can delete an article of a category' do
    step 'I navigate to edit templates of an inspectable group'

    template_to_delete = @group.templates.first

    find("input[value='#{template_to_delete.template_category.name}']").click
    within '.panel-collapse.in' do
      within(:xpath, "//input[@value='#{template_to_delete.article_name}']/ancestor::tr") do
        find('i.fa-minus-circle').click
      end
    end

    step 'I click on save'
    step 'I see a success message'
    expect{ template_to_delete.reload }.to raise_error ActiveRecord::RecordNotFound
  end

  step 'I can delete existing information of the fields' do
    step 'I navigate to edit templates of an inspectable group'
    pending
  end
end
