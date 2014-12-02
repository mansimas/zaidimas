Sprint.Views.Monsters ||= {}

class Sprint.Views.Monsters.NewView extends Backbone.View
  template: JST["backbone/templates/monsters/new"]

  events:
    "submit #new-monster": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (monster) =>
        @model = monster
        window.location.hash = "#/index"

      error: (monster, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
