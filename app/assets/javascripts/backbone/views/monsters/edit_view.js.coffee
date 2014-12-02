Sprint.Views.Monsters ||= {}

class Sprint.Views.Monsters.EditView extends Backbone.View
  template: JST["backbone/templates/monsters/edit"]

  events:
    "submit #edit-monster": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (monster) =>
        @model = monster
        window.location.hash = "#/index"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
