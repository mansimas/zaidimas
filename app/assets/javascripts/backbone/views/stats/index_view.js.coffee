Sprint.Views.Stats ||= {}

class Sprint.Views.Stats.IndexView extends Backbone.View
  template: JST["backbone/templates/stats/index"]
  constructor: (options) ->
    this.configure(options || {})
    Backbone.View.prototype.constructor.apply(this, arguments)

  configure: (options) ->
    if (this.options) 
      options = _.extend({}, _.result(this, 'options'), options)
    this.options = options
  initialize: () ->
    @options.stats.bind('reset', @addAll)

  send_monster_to_player: (attributes) ->
    statviews[0].attack_monster(attributes)

  use_this_item: (attributes) ->
    statviews[0].use_this_item(attributes)

  sell_item: (attributes) ->
    statviews[0].sell_item(attributes)

  buy_item: (attributes) ->
    statviews[0].buy_item(attributes)

  addAll: () =>
    @options.stats.each(@addOne)
  
  statviews = []
  addOne: (stat) =>
    view = new Sprint.Views.Stats.StatView({model : stat})
    statviews.push view
    @$("tbody").append(view.render().el)


  render: =>
    $(@el).html(@template(stats: @options.stats.toJSON() ))
    @addAll()

    return this
