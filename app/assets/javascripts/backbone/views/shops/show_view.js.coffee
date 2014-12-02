Sprint.Views.Shops ||= {}

class Sprint.Views.Shops.ShowView extends Backbone.View
  template: JST["backbone/templates/shops/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this

