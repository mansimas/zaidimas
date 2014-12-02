Sprint.Views.Chats ||= {}

class Sprint.Views.Chats.IndexView extends Backbone.View
  template: JST["backbone/templates/chats/index"]
  constructor: (options) ->
    this.configure(options || {})
    Backbone.View.prototype.constructor.apply(this, arguments)

  configure: (options) ->
    if (this.options) 
      options = _.extend({}, _.result(this, 'options'), options)
    this.options = options
  initialize: () ->
    @listenTo(@options.chats, 'reset', @addAll)
    @listenTo(@options.chats, 'add', @addOne)


  addAll: () =>
    @options.chats.each(@addOne)

  addOne: (chat) =>
    view = new Sprint.Views.Chats.ChatView({model : chat})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(chats: @options.chats.toJSON() ))
    @addAll()

    return this


