steps_for :templates do

  step 'a template category exists' do
    @group ||= Procurement::Group.all.detect {|g| g.inspectable_by?(@current_user) }
    FactoryGirl.create :procurement_template_category,
                       :with_templates,
                       group: @group
    expect(@group.templates).to be_exists
  end

  # step 'I navigate to edit templates of an inspectable group' do
  #   visit procurement.group_templates_path(@group)
  #   step 'a template category exists'
  # end

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

  # step 'the article name is filled out' do
  #   step 'I navigate to edit templates of an inspectable group'
  #
  #   @template = @group.templates.first
  #   expand_category @template.template_category.name
  #   within '.panel-collapse.in' do
  #     within(:xpath, "//input[@value='#{@template.article_name}']/ancestor::tr") do
  #       fill_in _('Article'), with: Faker::Lorem.sentence
  #     end
  #   end
  # end

  # step 'I can delete existing information of the fields' do |table|
  #   within '.panel-collapse.in' do
  #     within(:xpath, "//input[@value='#{@template.article_name}']/ancestor::tr") do
  #       table.raw.flatten.each do |value|
  #         case value
  #           when 'Price'
  #             find("input[name*='[price]']").set ''
  #           else
  #             fill_in _(value), with: ''
  #         end
  #       end
  #     end
  #   end
  #
  #   step 'I click on save'
  #   step 'I see a success message'
  # end

  private

  def expand_category(name)
    find("input[value='#{name}']").click
  end

end
