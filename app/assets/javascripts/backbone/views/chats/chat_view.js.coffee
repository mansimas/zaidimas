Sprint.Views.Chats ||= {}

class Sprint.Views.Chats.ChatView extends Backbone.View
  template: JST["backbone/templates/chats/chat"]

  tagName: "tr"

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    if router.stats.models[0].attributes.username is @model.attributes.username or router.stats.models[0].attributes.username is "adminas"
      window.location.hash = "#/index"
      @model.destroy()
      this.remove()
      return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
