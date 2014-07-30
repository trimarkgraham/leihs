class window.App.TestHandOverController extends Spine.Controller

  elements:
    "#assign-or-add-input": "input"
    "#add-start-date": "addStartDate"
    "#add-end-date": "addEndDate"

  events:
    "submit": "submit"

  submit: (e)=>
    e.preventDefault()
    e.stopImmediatePropagation()

    inventoryCode = @input.val()

    return false unless inventoryCode.length

    @el.find("#lines").load "/manage/#{App.InventoryPool.current.id}/contract_lines/assign_or_create",
      start_date: @getStartDate().format("YYYY-MM-DD")
      end_date: @getEndDate().format("YYYY-MM-DD")
      code: inventoryCode
      contract_id: @contract_id
      user_id: @user_id
      partial: true

    @input.val("")

  getStartDate: => moment(@addStartDate.val(), i18n.date.L)

  getEndDate: => moment(@addEndDate.val(), i18n.date.L)
