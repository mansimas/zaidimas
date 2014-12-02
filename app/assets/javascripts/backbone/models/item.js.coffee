class Sprint.Models.Item extends Backbone.Model
  paramRoot: 'stat'

  defaults:
    stat: null
    health: null
    strength: null
    user: null
    experience: null
    level: null
    player_hp: null
    max_hp: null
    monster_name: null
    monster_strength: null
    monster: null
    monster_hp: 0
    attack_allow: true
    monster_exp: 0
    money: 0
    monster_money: 0

class Sprint.Collections.ItemsCollection extends Backbone.Collection
  model: Sprint.Models.Item
  url: '/items'
