# encoding: utf-8


#Given /^I edit an order( that is not in the past)?$/ do |arg1|
#  @event = "order"
#  step "I open a contract for acknowledgement%s" % (arg1 ? ", whose start date is not in the past" : "")
#end

Given /^I am doing a take back( that is not overdue)?$/ do |arg1|
  @event = 'take_back'
  if arg1
    step 'I open a take back, not overdue'
  else
    step 'I open a take back'
  end
end

Given /^a model is no longer available$/ do
  if @event=='order' or @event=='hand_over'
    @entity = if @contract
                @contract
              else
                @customer.reservations_bundles.approved.find_by(inventory_pool_id: @current_inventory_pool)
              end
    reservation = @entity.item_lines.order('RAND()').first
    @model = reservation.model
    @initial_quantity = @contract.reservations.where(model_id: @model.id).count
    @max_before = reservation.model.availability_in(@entity.inventory_pool).maximum_available_in_period_summed_for_groups(reservation.start_date, reservation.end_date, reservation.group_ids) || 0
    step 'I add so many reservations that I break the maximal quantity of a model'
  else
    reservation = @reservations_to_take_back.where(option_id: nil).order('RAND()').first
    @model = reservation.model
    step 'I open a hand over to this customer'
    @max_before = @model.availability_in(@current_inventory_pool).maximum_available_in_period_summed_for_groups(reservation.start_date, reservation.end_date, reservation.group_ids) || 0
    step 'I add so many reservations that I break the maximal quantity of a model'
    visit manage_take_back_path(@current_inventory_pool, @customer)
  end
  find('.line', text: @model.name, match: :first)
  @lines = all('.line', text: @model.name)
  expect(@lines.size).to be > 0
  @max_before = [@max_before, 0].max
end

Then /^I see any problems displayed on the relevant reservations$/ do
  @problems = []
  @lines.each do |line|
      hover_for_tooltip line.find("[data-tooltip-template='manage/views/reservations/problems_tooltip']")
    @problems << find('.tooltipster-content strong', match: :first).text
  end
  @reference_line = @lines.first
  @reference_problem = @problems.first
  @line = if @reference_line['data-id']
            Reservation.find @reference_line['data-id']
          else
            Reservation.find JSON.parse(@reference_line['data-ids']).first
          end
  @av = @line.model.availability_in(@line.inventory_pool)
end

Then /^the problem is displayed as: "(.*?)"$/ do |format|
  regexp = if format == 'Nicht verfügbar 2(3)/7'
             /#{_("Not available")} -*\d\(-*\d\)\/\d/
           elsif format == 'Gegenstand nicht ausleihbar'
             /#{_("Item not borrowable")}/
           elsif format == 'Gegenstand ist defekt'
             /#{_("Item is defective")}/
           elsif format == 'Gegenstand ist unvollständig'
             /#{_("Item is incomplete")}/
           elsif format == 'Überfällig seit 6 Tagen'
             /(Überfällig seit \d+ (Tagen|Tag)|#{_("Overdue")} #{_("since")} \d+ (days|day))/
           end
  @problems.each do |problem|
    expect(problem.match(regexp)).not_to be_nil
  end
end

Then /^"(.*?)" are available for the user, also counting availability from groups the user is member of$/ do |arg1|
  max = if [:unsubmitted, :submitted].include? @line.status
          @initial_quantity + @max_before
        elsif [:approved, :signed].include? @line.status
          (@av.maximum_available_in_period_summed_for_groups(@line.start_date, @line.end_date, @line.group_ids) || 0) \
            + 1 # free up self blocking
        else
          @max_before - @quantity_added
        end
  expect(@reference_problem).to match /#{max}\(/
end

Then /^"(.*?)" are available in total, also counting availability from groups the user is not member of$/ do |arg1|
  max = @av.maximum_available_in_period_summed_for_groups(@line.start_date, @line.end_date, @av.inventory_pool_and_model_group_ids) || 0
  if [:unsubmitted, :submitted].include? @line.status
    max += @line.contract.reservations.where(start_date: @line.start_date, end_date: @line.end_date, model_id: @line.model).size
  else
    max += @line.quantity
  end
  expect(@reference_problem).to match(/\(#{max}/)
end

Then /^"(.*?)" are in this inventory pool \(and borrowable\)$/ do |arg1|
  expect(@reference_problem).to match("/#{@line.model.items.where(inventory_pool_id: @line.inventory_pool).borrowable.size}")
end

Given /^one item is not borrowable$/ do
  case @event
    when 'hand_over'
      @item = @current_inventory_pool.items.in_stock.unborrowable.order('RAND()').first
      step 'I add an item to the hand over'
      @line_id = Reservation.where(item_id: @item.id).first.id
      find(".line[data-id='#{@line_id}']", text: @item.model.name).find('[data-assign-item][disabled]')
    when 'take_back'
      @line_id = find(".line[data-line-type='item_line']", match: :first)[:"data-id"]
      step 'I mark the item as not borrowable'
    else
      raise
  end
end

Given /^I take back a(n)?( late)? item$/ do |grammar, is_late|
  @event = 'take_back'
  overdued_take_backs = @current_inventory_pool.visits.take_back.select{|v| v.reservations.any? {|l| l.is_a? ItemLine}}
  overdued_take_backs = overdued_take_backs.select { |x| x.date < Date.today } if is_late
  overdued_take_back = overdued_take_backs.sample
  @line_id = overdued_take_back.reservations.where(type: 'ItemLine').order('RAND()').first.id
  visit manage_take_back_path(@current_inventory_pool, overdued_take_back.user)
  expect(has_selector?(".line[data-id='#{@line_id}']")).to be true
end

def open_inspection_for_line(line_id)
  within(".line[data-id='#{line_id}'] .multibutton") do
    find('.dropdown-toggle').click
    find('.dropdown-holder .dropdown-item', text: _('Inspect')).click
  end
  find('.modal')
end

Then /^I mark the item as (.*)$/ do |arg1|
  open_inspection_for_line(@line_id)
  case arg1
    when 'not borrowable'
      find("select[name='is_borrowable']").select 'Unborrowable'
    when 'defective'
      find("select[name='is_broken']").select 'Defective'
    when 'incomplete'
      find("select[name='is_incomplete']").select 'Incomplete'
    else
      raise
  end
  find(".modal button[type='submit']").click
end

When /^one item is defective$/ do
  case @event
    when 'hand_over'
      @item = @current_inventory_pool.items.in_stock.broken.order('RAND()').first
      step 'I add an item to the hand over'
      sleep 1
      @line_id = find("input[value='#{@item.inventory_code}']").find(:xpath, 'ancestor::div[@data-id]')['data-id']
    when 'take_back'
      @line_id = find(".line[data-line-type='item_line']", match: :first)[:"data-id"]
      step 'I mark the item as defective'
    else
      raise
  end
end

Given /^one item is incomplete$/ do
  case @event
    when 'hand_over'
      @item = @current_inventory_pool.items.in_stock.incomplete.order('RAND()').first
      step 'I add an item to the hand over'
      @line_id = find("input[value='#{@item.inventory_code}']").find(:xpath, 'ancestor::div[@data-id]')['data-id']
    when 'take_back'
      @line_id = find(".line[data-line-type='item_line']", match: :first)[:"data-id"]
      step 'I mark the item as incomplete'
    else
      raise
  end
end

Then(/^the last added model line shows the line's problem$/) do
  @line = @model.reservations.last
  @av = @model.availability_in(@line.inventory_pool)
  line = all(".line[data-id='#{@line.id}']", text: @model.name).last
  hover_for_tooltip line.find(".emboss.red")
  @problems = []
  @problems << find('.tooltipster-default .tooltipster-content', text: /\w/).text
  @reference_problem = @problems.first
end

Then /^the affected item's line shows the item's problems$/ do
  target = find(".line[data-id='#{@line_id}'] .emboss.red")
  hover_for_tooltip target
  @problems = []
  @problems << find('.tooltipster-default .tooltipster-content', text: /\w/).text
end
