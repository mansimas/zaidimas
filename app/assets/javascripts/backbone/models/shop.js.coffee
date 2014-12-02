class Sprint.Models.Shop extends Backbone.Model
  paramRoot: 'shop'

  defaults:
    id: null
    name: null
    user_id: null
    count: null
    health: null
    strength: null
    experience: null
    level: null
    hp: null
    money: null
    min_dmg: null
    max_dmg: null
    speed: null
    agility: null
    defence: null
    critical: null
    critical_multiplier: null
    itemname: null
    grade: null
    username: null

class Sprint.Collections.ShopsCollection extends Backbone.Collection
  model: Sprint.Models.Shop
  url: '/shops'
