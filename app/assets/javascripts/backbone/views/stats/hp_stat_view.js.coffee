Sprint.Views.Stats ||= {}

class Sprint.Views.Stats.hp_StatView extends Backbone.View
  template: JST["backbone/templates/stats/hp_stat"]
  initialize: ->
    @listenTo @model, 'change', @render
    @hp_ad()
    
  alfas = "true"
  medicine_using = 30
  
  window.delay = (ms, fn)-> setTimeout(fn, ms)
  window.timer = (ms, fn)-> setInterval(fn, ms)
      
  hp_ad: ->
    if alfas is "true"
      @hp_added()
      alfas = "false"

  hp_added: ->
    self = this
    timer 1000, ()-> self.hp_adding()

  hp_adding: ->
    if @model.attributes.player_hp < @model.attributes.max_hp
      @model.set(player_hp: @model.attributes.player_hp+parseInt((20+@model.attributes.level+@model.attributes.max_hp/100)/4))
      @model.save()
      if @model.attributes.medicine_time > 0
        @model.set(medicine_time: @model.attributes.medicine_time - 1)
      if @model.attributes.medicine_time <= 0
        @model.set(medicine_time: 0)
    if @model.attributes.player_hp is @model.attributes.max_hp
      if @model.attributes.medicine_time > 0
        @model.set(medicine_time: @model.attributes.medicine_time - 1)
      if @model.attributes.medicine_time <= 0
        @model.set(medicine_time: 0)
    if @model.attributes.player_hp > @model.attributes.max_hp
      @model.set(player_hp: @model.attributes.max_hp)
      
    
    
  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this