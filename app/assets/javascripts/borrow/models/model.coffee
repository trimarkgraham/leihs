window.App.Model.url = => "/borrow/models"

window.App.Model.hasMany "availabilities", "App.Availability", "model_id"

window.App.Model::availableQuantityForInventoryPools = (inventory_pool_ids)->
  return undefined unless @plainAvailabilities().all().length
  _.reduce @plainAvailabilities().all(), (memory, av)->
    if _.include(inventory_pool_ids, av.inventory_pool_id)
      memory + av.quantity 
    else
      0
  , 0