class WelcomeController < ApplicationController


  # GET /stats
  # GET /stats.json
  
  def index    
    monster_list = $redis.lrange('mobs', 0, -1)
    monster_object = []
    for monster in monster_list do
      id = monster.to_i
      xpos = -100
      ypos = -100
      xposDest = -100
      yposDest = -100
      monster_object[id] = {id: id, xpos: xpos, ypos: ypos, xposDest: xposDest, yposDest: yposDest}
    end  
    
    @monsters = monster_object
    @items = Stat.all
    @inventories = Inventory.where(user_id: current_user.id)
    @shops = Shop.all
    @stats = Stat.find_by_user_id(current_user.id)
    @chats = Chat.all 
  end
end
