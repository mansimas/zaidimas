Sprint.Views.Stats ||= {}

class Sprint.Views.Stats.meds_StatView extends Backbone.View
  template: JST["backbone/templates/stats/meds_stat"]
  
  initialize: ->
    @listenTo @model, 'change', @render
    
  events:
    "click .use_medicine1" : "use_medicine1"
    "click .use_medicine2" : "use_medicine2"
    "click .use_medicine3" : "use_medicine3"
    "click .use_medicine4" : "use_medicine4"
    "click .use_medicine5" : "use_medicine5"
    "click .use_medicine6" : "use_medicine6"
    "click .use_medicine7" : "use_medicine7"
    "click .use_medicine8" : "use_medicine8"
    "click .use_medicine9" : "use_medicine9"
    "click .use_medicine10" : "use_medicine10"

  use_medicine1: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine1 > 0
        @model.set(player_hp: @model.attributes.player_hp + 100, medicine1: @model.attributes.medicine1-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine2: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine2 > 0
        @model.set(player_hp: @model.attributes.player_hp + 200, medicine2: @model.attributes.medicine2-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine3: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine3 > 0
        @model.set(player_hp: @model.attributes.player_hp + 300, medicine3: @model.attributes.medicine3-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine4: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine4 > 0
        @model.set(player_hp: @model.attributes.player_hp + 400, medicine4: @model.attributes.medicine4-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine5: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine5 > 0
        @model.set(player_hp: @model.attributes.player_hp + 500, medicine5: @model.attributes.medicine5-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine6: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine6 > 0
        @model.set(player_hp: @model.attributes.player_hp + 600, medicine6: @model.attributes.medicine6-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine7: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine7 > 0
        @model.set(player_hp: @model.attributes.player_hp + 700, medicine7: @model.attributes.medicine7-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine8: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine8 > 0
        @model.set(player_hp: @model.attributes.player_hp + 800, medicine8: @model.attributes.medicine8-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine9: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine9 > 0
        @model.set(player_hp: @model.attributes.player_hp + 900, medicine9: @model.attributes.medicine9-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
  use_medicine10: (e) ->
    if @model.attributes.medicine_time is 0
      if @model.attributes.medicine10 > 0
        @model.set(player_hp: @model.attributes.player_hp + 1000, medicine10: @model.attributes.medicine10-1, medicine_time: 5)
        @model.save()
        @model.check_attributes()
        
        
  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this