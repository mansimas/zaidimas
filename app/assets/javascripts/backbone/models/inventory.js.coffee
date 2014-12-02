class Sprint.Models.Inventory extends Backbone.Model
  paramRoot: 'inventory'

  defaults:
    id: null
    price: 0

class Sprint.Collections.InventoriesCollection extends Backbone.Collection
  model: Sprint.Models.Inventory
  url: '/inventories'
