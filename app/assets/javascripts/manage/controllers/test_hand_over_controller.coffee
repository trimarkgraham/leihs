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

    App.ContractLine.assignOrCreate
      start_date: @getStartDate().format("YYYY-MM-DD")
      end_date: @getEndDate().format("YYYY-MM-DD")
      code: inventoryCode
      contract_id: @contract_id

    .done((data) => @el.find("#lines").load("/manage/1/users/#{@user_id}/hand_over #lines"))

    .error((e) =>
      App.Flash
          type: "error"
          message: e.responseText)

    @input.val("")

  getStartDate: => moment(@addStartDate.val(), i18n.date.L)

  getEndDate: => moment(@addEndDate.val(), i18n.date.L)
