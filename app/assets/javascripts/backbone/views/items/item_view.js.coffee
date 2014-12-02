Sprint.Views.Items ||= {}

class Sprint.Views.Items.ItemView extends Backbone.View
  template: JST["backbone/templates/items/item"]

  initialize: ->
    @listenTo @model, 'change', @render

  events:
    "click .attack"  : "attack"

  tagName: "tr"

  attack: (e) ->
    e.preventDefault()
    attributes = this.model.attributes
    router.send_monster_to_root(attributes)

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
