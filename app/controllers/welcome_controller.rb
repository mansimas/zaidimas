class WelcomeController < ApplicationController


  # GET /stats
  # GET /stats.json
  
  def index    
    monster_list = $redis.lrange('mobs', 0, -1)
    monster_object = []
    for monster in monster_list do
      id = ($redis.hget "mobs:#{monster}", 'id').to_i
      xpos = ($redis.hget "mobs:#{monster}", 'xposDest').to_f
      ypos = ($redis.hget "mobs:#{monster}", 'yposDest').to_f
      xposDest = ($redis.hget "mobs:#{monster}", 'xposDest').to_i
      yposDest = ($redis.hget "mobs:#{monster}", 'yposDest').to_i
      level = ($redis.hget "mobs:#{monster}", 'level').to_i
      health = ($redis.hget "mobs:#{monster}", 'health').to_i
      monster_object[id] = {id: id, Xpos: xpos, Ypos: ypos, XposDest: xposDest, YposDest: yposDest, level:level, health:health}
    end  
    
    @monsters = monster_object
    @items = Stat.all
    @inventories = Inventory.where(user_id: current_user.id)
    @shops = Shop.all
    @stats = Stat.find_by_user_id(current_user.id)
    @chats = Chat.all 
    
  end
end
