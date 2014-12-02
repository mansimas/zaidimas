Sprint.Views.Inventories ||= {}

class Sprint.Views.Inventories.InventoryView extends Backbone.View
  template: JST["backbone/templates/inventories/inventory"]


  initialize: ->
    @listenTo @model, 'change', @render
    @listenTo @model, 'reset', @render

  events:
    "click .use" : "use"
    "click .destroy" : "destroy"

  destroy: () ->
    window.location.hash = "#/index"
    attributes = this.model.attributes
    router.sell_item(attributes)
    @model.destroy()
    this.remove()
    return false

  use: (e) ->
    e.preventDefault()
    this_player = router.stats.models[0]
    if @model.attributes.itemname is "weapon"
      if this_player.attributes.weapon_itemname is "weapon"
        #do nothing
      else 
        if this_player.attributes.level >= @model.attributes.level 
          window.location.hash = "#/index"
          router.use_this_item(@model.attributes)
          @model.destroy()
          this.remove()
          return false
    if @model.attributes.itemname is "armor"
      if this_player.attributes.armor_itemname is "armor"
        #do nothing
      else 
        if this_player.attributes.level >= @model.attributes.level 
          window.location.hash = "#/index"
          router.use_this_item(@model.attributes)
          @model.destroy()
          this.remove()
          return false
    if @model.attributes.itemname is "gloves"
      if this_player.attributes.gloves_itemname is "gloves"
        #do nothing
      else 
        if this_player.attributes.level >= @model.attributes.level 
          window.location.hash = "#/index"
          router.use_this_item(@model.attributes)
          @model.destroy()
          this.remove()
          return false
    if @model.attributes.itemname is "shoes"
      if this_player.attributes.shoes_itemname is "shoes"
        #do nothing
      else 
        if this_player.attributes.level >= @model.attributes.level 
          window.location.hash = "#/index"
          router.use_this_item(@model.attributes)
          @model.destroy()
          this.remove()
          return false
    if @model.attributes.itemname is "helmet"
      if this_player.attributes.helmet_itemname is "helmet"
        #do nothing
      else 
        if this_player.attributes.level >= @model.attributes.level 
          window.location.hash = "#/index"
          router.use_this_item(@model.attributes)
          @model.destroy()
          this.remove()
          return false

  tagName: "tr"

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
