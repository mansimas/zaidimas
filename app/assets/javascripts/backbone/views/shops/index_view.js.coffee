Sprint.Views.Shops ||= {}

class Sprint.Views.Shops.IndexView extends Backbone.View
  template: JST["backbone/templates/shops/index"]
  constructor: (options) ->
    this.configure(options || {})
    Backbone.View.prototype.constructor.apply(this, arguments)

  configure: (options) ->
    if (this.options) 
      options = _.extend({}, _.result(this, 'options'), options)
    this.options = options
  initialize: () ->
    @listenTo(@options.shops, 'reset', @addAll)
    @listenTo(@options.shops, 'add', @addOne)

  shop_this_item: (attributes) ->
    wait: true
    @options.shops.create(price: attributes.price, name: attributes.item, user_id: router.stats.models[0].attributes.user_id, money: attributes.money, strength:attributes.strength, health: attributes.health, agility:attributes.agility, level:attributes.level, defence: attributes.defence, itemname: attributes.itemname, grade:attributes.grade, username: router.stats.models[0].attributes.username )
    wait: true

  addAll: () =>
    @options.shops.each(@addOne)

  addOne: (shop) =>
    view = new Sprint.Views.Shops.ShopView({model : shop})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(shops: @options.shops.toJSON() ))
    @addAll()

    return this
