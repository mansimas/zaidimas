Sprint.Views.Monsters ||= {}

class Sprint.Views.Monsters.IndexView extends Backbone.View
  template: JST["backbone/templates/monsters/index"]
  constructor: (options) ->
    this.configure(options || {})
    Backbone.View.prototype.constructor.apply(this, arguments)

  configure: (options) ->
    if (this.options) 
      options = _.extend({}, _.result(this, 'options'), options)
    this.options = options


  events:
    "click .create_monster_1_5" : "create_monster_1_5"
    "click .create_monster_5_10" : "create_monster_5_10"
    "click .create_monster_10_15" : "create_monster_10_15"
    "click .create_monster_15_20" : "create_monster_15_20"

  create_monster_1_5: () ->
    monster_level = 0
    for count in [0...5]
      monster_level = monster_level + 1
      monster_rang = 1
      this.collection = new Sprint.Collections.MonstersCollection
      this.model = new this.collection.model(name: "monster"+monster_level, level: monster_level, rang: monster_rang, 
      health: 30+monster_level*20*monster_rang, experience: monster_level*monster_rang, money: monster_level*monster_rang, 
      min_dmg: 2+monster_level*monster_rang*2, max_dmg: monster_level+monster_level*monster_rang*5, 
      speed: 1000+monster_level*monster_rang, defence: monster_level*monster_rang*2, 
      critical: parseInt(1+parseInt((monster_rang*monster_level)/10)), critical_multiplier: 2, attacker: 3, Xpos: 500, 
      Ypos: 250, XposDest: 550, YposDest : 270 )
      this.collection.create(this.model.toJSON())
      wait: true

  create_monster_5_10: () ->
    monster_level = 5
    for count in [0...5]
      monster_level = monster_level + 1
      monster_rang = 1
      this.collection = new Sprint.Collections.MonstersCollection
      this.model = new this.collection.model(name: "monster"+monster_level, level: monster_level, rang: monster_rang, 
      health: monster_level*60*monster_rang-200, experience: monster_level*monster_rang, money: monster_level*monster_rang, 
      min_dmg: monster_level*monster_rang*2, max_dmg: monster_level*monster_rang*8, speed: 1000+monster_level*monster_rang, 
      defence: monster_level*monster_rang*2, critical: parseInt(1+parseInt((monster_rang*monster_level)/10)), 
      critical_multiplier: 2, attacker: 3, Xpos: 500, Ypos: 250, XposDest: 550, YposDest : 270 )
      this.collection.create(this.model.toJSON())
      wait: true

  create_monster_10_15: () ->
    monster_level = 10
    for count in [0...5]
      monster_level = monster_level + 1
      monster_rang = 1
      this.collection = new Sprint.Collections.MonstersCollection
      this.model = new this.collection.model(name: "monster"+monster_level, level: monster_level, rang: monster_rang, 
      health: monster_level*80*monster_rang-200, experience: monster_level*monster_rang*2, 
      money: monster_level*monster_rang, min_dmg: monster_level*monster_rang*2, max_dmg: monster_level*monster_rang*11, 
      speed: 1000+monster_level*monster_rang, defence: monster_level*monster_rang*2, 
      critical: parseInt(1+parseInt((monster_rang*monster_level)/10)), critical_multiplier: 2, attacker: 3, 
      Xpos: 500, Ypos: 250, XposDest: 550, YposDest : 270  )
      this.collection.create(this.model.toJSON())
      wait: true

  create_monster_15_20: () ->
    monster_level = 15
    for count in [0...5]
      monster_level = monster_level + 1
      monster_rang = 1
      this.collection = new Sprint.Collections.MonstersCollection
      this.model = new this.collection.model(name: "monster"+monster_level, level: monster_level, rang: monster_rang, 
      health: monster_level*80*monster_rang-200, experience: monster_level*monster_rang*2, money: monster_level*monster_rang, 
      min_dmg: monster_level*monster_rang*2, max_dmg: monster_level*monster_rang*15, speed: 1000+monster_level*monster_rang, 
      defence: monster_level*monster_rang*2, critical: parseInt(1+parseInt((monster_rang*monster_level)/10)), 
      critical_multiplier: 2, attacker: 3, Xpos: 500, Ypos: 250, XposDest: 550, YposDest : 270  )
      this.collection.create(this.model.toJSON())
      wait: true

  
  send_monster_to_monsters: (attributes) ->
    monsterviews[attributes].attack_monster()
       
  initialize: () ->
    @options.monsters.bind('reset', @addAll)
    
  addAll: () =>
    @options.monsters.each(@addOne)
    
  monsterviews = []
  addOne: (monster) =>
    
    #view = new Sprint.Views.Monsters.MonsterView({model : monster})
    #monsterviews.push view
    #@$("tbody").append(view.render().el)
    
  render: =>
    @$el.html(@template(monsters: @options.monsters.toJSON() ))
    @addAll()

    return this