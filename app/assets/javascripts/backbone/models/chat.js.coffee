class Sprint.Models.Chat extends Backbone.Model
  paramRoot: 'redis'

class Sprint.Collections.ChatsCollection extends Backbone.Collection
  model: Sprint.Models.Chat
  url: '/redis'
