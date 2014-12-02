Sprint.Views.Inventories ||= {}

class Sprint.Views.Inventories.ShowView extends Backbone.View
  template: JST["backbone/templates/inventories/show"]

  events:
    "click .use" : "use"
    "click .destroy" : "destroy"
    "click .shop" : "shop"
    "change #price" :"set_price"

  set_price: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if @model.attributes.itemname is "weapon" or "armor" or "gloves" or "helmet" or "shoes"    
      @model.set(price: e.target.value)
      @model.save()

  shop: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if @model.attributes.itemname is "weapon" or "armor" or "gloves" or "helmet" or "shoes"
      if 0 < @model.attributes.price < 2000000000
        window.location.hash = "#/index"
        router.shop_this_item(@model.attributes)
        @model.destroy()
        this.remove()
        return false

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

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this

