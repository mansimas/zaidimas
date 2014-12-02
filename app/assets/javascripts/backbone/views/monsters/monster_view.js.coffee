Sprint.Views.Monsters ||= {}

class Sprint.Views.Monsters.MonsterView extends Backbone.View
  template: JST["backbone/templates/monsters/monster"]

  initialize: ->
    @listenTo @model, 'change', @render


  events:
    "click .destroy" : "destroy"
    "click .attack"  : "attack"


  tagName: "tr"

  attack: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if router.stats.models[0].attributes.attack_allow is true
      attributes = this.model.attributes
      router.send_monster_to_root(attributes)
      window.location.hash = "#/index"

  attack_monster: () ->
    if router.stats.models[0].attributes.attack_allow is true
      attributes = this.model.attributes
      router.send_monster_to_root(attributes)
      window.location.hash = "#/index"
    
  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this