steps_for :templates do

  step 'a template category exists' do
    @group ||= Procurement::Group.all.detect {|g| g.inspectable_by?(@current_user) }
    @category = FactoryGirl.create :procurement_template_category,
                                   group: @group
  end

  step 'I navigate to edit templates of an inspectable group' do
    visit procurement.group_templates_path(@group)
  end

  # step 'I can delete an article of a category' do
  #   step 'I navigate to edit templates of an inspectable group'
  #
  #   template = @group.templates.first
  #   expand_category template.template_category.name
  #   within '.panel-collapse.in' do
  #     within(:xpath, "//input[@value='#{template.article_name}']/ancestor::tr") do
  #       find('i.fa-minus-circle').click
  #     end
  #   end
  #
  #   step 'I click on save'
  #   step 'I see a success message'
  #   expect{ template.reload }.to raise_error ActiveRecord::RecordNotFound
  # end

  step 'I delete the following fields' do |table|
    within '.panel-collapse.in' do
      within(:xpath, "//input[@value='#{@template.article_name}']/ancestor::tr") do
        table.raw.flatten.each do |value|
          case value
            when 'Price'
              find("input[name*='[price]']").set ''
            else
              fill_in _(value), with: ''
          end
        end
      end
    end
  end

  step 'the deleted data is deleted from the database' do
    @template.reload

    expect(@template.article_name).not_to be_empty

    expect(@template.article_number).to be_nil
    expect(@template.price).to be_zero
    expect(@template.supplier).to be_nil
  end

  step 'the following fields are filled' do |table|
    expand_category @category.name
    within '.panel-collapse.in' do
      within(:xpath, "//input[@value='#{@template.article_name}']/ancestor::tr") do
        table.raw.flatten.each do |value|
          case value
            when 'Price'
              find("input[name*='[price]']").set 123
            else
              fill_in _(value), with: Faker::Lorem.sentence
          end
        end
      end
    end
  end

  step 'the template category has one article' do
    @template = FactoryGirl.create(:procurement_template)
    @category.templates << @template
    expect(@category.templates.count).to eq 1
  end

  private

  def expand_category(name)
    find("input[value='#{name}']").click
  end

end
