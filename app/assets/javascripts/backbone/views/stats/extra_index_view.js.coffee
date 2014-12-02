Sprint.Views.Stats ||= {}

class Sprint.Views.Stats.extra_IndexView extends Backbone.View
  template: JST["backbone/templates/stats/hp_index"]
  template1: JST["backbone/templates/stats/meds_index"]
  constructor: (options) ->
    this.configure(options || {})
    Backbone.View.prototype.constructor.apply(this, arguments)
  configure: (options) ->
    if (this.options) 
      options = _.extend({}, _.result(this, 'options'), options)
    this.options = options
    
  initialize: () ->
    @options.stats.bind('reset', @addAll)

  addAll: () =>
    @options.stats.each(@addOne)
  
  addOne: (stat) =>
    view = new Sprint.Views.Stats.hp_StatView({model : stat})
    @$("tbody").append(view.render().el)
    view = new Sprint.Views.Stats.meds_StatView({model: stat})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(stats: @options.stats.toJSON() ))
    $(@el).html(@template1(stats: @options.stats.toJSON() ))
    @addAll()

    return this
