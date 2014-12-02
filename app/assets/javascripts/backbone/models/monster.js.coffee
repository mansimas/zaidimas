class Sprint.Models.Monster extends Backbone.Model
  paramRoot: 'monster'
  
class Sprint.Collections.MonstersCollection extends Backbone.Collection
  model: Sprint.Models.Monster
  url: '/monsters'

