Sprint.Views.Inventories ||= {}

class Sprint.Views.Inventories.IndexView extends Backbone.View
  template: JST["backbone/templates/inventories/index"]
  constructor: (options) ->
    this.configure(options || {})
    Backbone.View.prototype.constructor.apply(this, arguments)

  configure: (options) ->
    if (this.options) 
      options = _.extend({}, _.result(this, 'options'), options)
    this.options = options
  initialize: () ->
    @listenTo(@options.inventories, 'reset', @addAll)
    @listenTo(@options.inventories, 'add', @addOne)

  create_item: (attributes) ->
    @options.inventories.create(item: attributes.name, user_id: router.stats.models[0].attributes.user_id, money: attributes.money, strength:attributes.strength, health: attributes.health, agility:attributes.agility, level:attributes.level, defence: attributes.defence, itemname: attributes.itemname, grade:attributes.grade)

  bought_item: (attributes) ->
    @options.inventories.create(item: attributes.name, user_id: attributes.user_id, money: attributes.money, strength:attributes.strength, health: attributes.health, agility:attributes.agility, level:attributes.level, defence: attributes.defence, grade:attributes.grade, itemname: attributes.itemname)

  addAll: () =>
    @options.inventories.each(@addOne)

  addOne: (inventory) =>
    if inventory.attributes.user_id is router.stats.models[0].attributes.user_id 
      view = new Sprint.Views.Inventories.InventoryView({model : inventory})
      @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(inventories: @options.inventories.toJSON() ))
    @addAll()
    return this

    



