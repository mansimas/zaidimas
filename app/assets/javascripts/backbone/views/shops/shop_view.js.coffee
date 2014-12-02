Sprint.Views.Shops ||= {}

class Sprint.Views.Shops.ShopView extends Backbone.View
  template: JST["backbone/templates/shops/shop"]

  events:
    "click .destroy" : "destroy"
    "click .buy" : "buy"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  buy: () ->
    if router.stats.models[0].attributes.user_id is @model.attributes.user_id
      router.send_item_to_inventory(@model.attributes)
      @model.destroy()
      this.remove()
      return false
    else
      if router.stats.models[0].attributes.money >= @model.attributes.price
        router.send_item_to_inventory(@model.attributes)
        router.bought_item(stats = money:@model.attributes.price, user_id: @model.attributes.user_id, name: "sold #{@model.attributes.name}", level:1, itemname: "sold item" )
        router.buy_item(@model.attributes)
        @model.destroy()
        this.remove()
        return false

  tagName: "tr"

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
