class WelcomeController < ApplicationController


  # GET /stats
  # GET /stats.json
  def index    
    monster_list = $redis.lrange('mobs', 0, -1)
    monster_object = []
    for mob in monster_list do
      id = mob.to_i
      xpos = ($redis.hget "mobs:#{mob}", 'xpos').to_i
      ypos = ($redis.hget "mobs:#{mob}", 'ypos').to_i
      xposDest = ($redis.hget "mobs:#{mob}", 'xposDest').to_i
      yposDest = ($redis.hget "mobs:#{mob}", 'yposDest').to_i     
      level = ($redis.hget "mobs:#{mob}", 'level').to_i
      health = ($redis.hget "mobs:#{mob}", 'health').to_i
      max_health = ($redis.hget "mobs:#{mob}", 'max_health').to_i
      attacked = ($redis.hget "mobs:#{mob}", 'attacked').to_i
      monster_object[id] = {id: id, xpos: xpos, ypos: ypos, xposDest: xposDest, yposDest: yposDest,
      level:level, health:health, max_health:max_health, attacked:attacked}
    end  
    
    @monsters = monster_object
    @items = Stat.all
    @inventories = Inventory.where(user_id: current_user.id)
    @shops = Shop.all
    @stats = Stat.find_by_user_id(current_user.id)
    @chats = Chat.all 
  end
end
