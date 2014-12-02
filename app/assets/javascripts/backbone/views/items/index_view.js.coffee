Sprint.Views.Items ||= {}

class Sprint.Views.Items.IndexView extends Backbone.View
  template: JST["backbone/templates/items/index"]

  constructor: (options) ->
    this.configure(options || {})
    Backbone.View.prototype.constructor.apply(this, arguments)

  configure: (options) ->
    if (this.options) 
      options = _.extend({}, _.result(this, 'options'), options)
    this.options = options

  initialize: () ->
    @options.items.bind('reset', @addAll)

  addAll: () =>
    @options.items.each(@addOne)

        
  addOne: (item) =>
    this_player = router.stats.models[0].attributes
    all_players = item.attributes
    view = new Sprint.Views.Items.ItemView({model : item})
    if this_player.user_id isnt all_players.user_id
      @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(items: @options.items.toJSON() ))
    @addAll()

    return this
