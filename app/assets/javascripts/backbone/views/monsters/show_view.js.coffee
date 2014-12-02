Sprint.Views.Monsters ||= {}

class Sprint.Views.Monsters.ShowView extends Backbone.View
  template: JST["backbone/templates/monsters/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
