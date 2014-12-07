class HardWorker < WebsocketRails::BaseController
  include Sidekiq::Worker
  require 'sidekiq/api'
  
  def perform
    sleep 2
    puts "started background job"
    self.recalculate
  end
  
  def player_killed_enemy
    puts data
    $redis.hset "mobs:#{data}", 'attacked', 0
  end
  
  def player_attacks_enemy
    $redis.pipelined do
      $redis.hset "mobs:#{data[:id]}", 'xpos', data[:xpos]
      $redis.hset "mobs:#{data[:id]}", 'ypos', data[:ypos]
      $redis.hset "mobs:#{data[:id]}", 'xposDest', data[:xpos]
      $redis.hset "mobs:#{data[:id]}", 'yposDest', data[:ypos]
      $redis.hset "mobs:#{data[:id]}", 'attacked', 1
    end
    mob = {id:data[:id], xpos:data[:xpos], ypos:data[:ypos], attacked:1,
    xposDest:data[:xpos], yposDest:data[:ypos], health:data[:health], level:data[:level], max_health:data[:max_health]}
    WebsocketRails[:channel_name].trigger(:event_name, mob)
  end
  
  def reset_database
    $redis.pipelined do
      (0...20).each do |mob_count|
        $redis.rpush "mobs", mob_count
        $redis.hset "mobs:#{mob_count}", 'id', "#{mob_count}"
        $redis.hset "mobs:#{mob_count}", 'xpos', 150
        $redis.hset "mobs:#{mob_count}", 'ypos', 125
        $redis.hset "mobs:#{mob_count}", 'xposDest', 175
        $redis.hset "mobs:#{mob_count}", 'yposDest', 150
        $redis.hset "mobs:#{mob_count}", 'level', "#{mob_count}"
        $redis.hset "mobs:#{mob_count}", 'attacked', 0
        if mob_count == 0
          $redis.hset "mobs:#{mob_count}", 'health', 10
          $redis.hset "mobs:#{mob_count}", 'max_health', 10
        else
          $redis.hset "mobs:#{mob_count}", 'health', "#{(mob_count*25)}"
          $redis.hset "mobs:#{mob_count}", 'max_health', "#{(mob_count*25)}"
        end
      end
    end
  end

  def recalculate
    @monster_list = $redis.lrange('mobs', 0, -1)
    @monster_object= []
    @reload_rate = 0.5
    @mob_speed = 5*@reload_rate
    
    def update_database
      for monster in @monster_list do
        id = ($redis.hget "mobs:#{monster}", 'id').to_i
        xpos = ($redis.hget "mobs:#{monster}", 'xpos').to_f
        ypos = ($redis.hget "mobs:#{monster}", 'ypos').to_f
        xposDest = ($redis.hget "mobs:#{monster}", 'xposDest').to_f
        yposDest = ($redis.hget "mobs:#{monster}", 'yposDest').to_f
        level = ($redis.hget "mobs:#{monster}", 'level').to_i
        health = ($redis.hget "mobs:#{monster}", 'health').to_i
        max_health = ($redis.hget "mobs:#{monster}", 'max_health').to_i
        attacked = ($redis.hget "mobs:#{monster}", 'attacked').to_i   
        steps = (Math.sqrt((xposDest-xpos)*(xposDest-xpos)+(yposDest-ypos)*(yposDest-ypos))/@mob_speed).to_i
        @monster_object[id] = {id:id, xpos:xpos, ypos:ypos, xposDest:xposDest, attacked:attacked, 
        yposDest:yposDest, level:level, health:health, max_health:max_health, steps:steps}
        WebsocketRails[:channel_name].trigger(:event_name, @monster_object[id])
      end  
    end
    
    def check_monsters
      (1..(2**(0.size * 8 -2) -1)).each do |number|
        for monster in @monster_object do
          attacked = ($redis.hget "mobs:#{monster[:id]}", 'attacked').to_i
          @monster_object[monster[:id]][:attacked] = attacked
          if attacked == 0
            @monster_object[monster[:id]][:steps] -= 1
          end           
          if monster[:steps] <= 0
            recalculateMobDestination(monster)
          end
        end
        sleep @reload_rate
      end
    end
    
    def recalculateMobDestination(monster)
      spawn_radius = 100
      newXpos = (sprintf '%.3f', (Random.new.rand((monster[:xposDest]-spawn_radius)...(monster[:xposDest]+spawn_radius)))).to_f
      newYpos = (sprintf '%.3f', (Random.new.rand((monster[:yposDest]-spawn_radius)...(monster[:yposDest]+spawn_radius)))).to_f  
      if 0 < newXpos &&  newXpos < 1100 && 0 < newYpos && newYpos < 380
        $redis.pipelined do
          $redis.hset "mobs:#{monster[:id]}", 'xpos', monster[:xposDest]
          $redis.hset "mobs:#{monster[:id]}", 'ypos', monster[:yposDest]
          $redis.hset "mobs:#{monster[:id]}", 'xposDest', newXpos
          $redis.hset "mobs:#{monster[:id]}", 'yposDest', newYpos
        end
        steps = (Math.sqrt((newXpos-monster[:xposDest])*(newXpos-monster[:xposDest])+
        (newYpos-monster[:yposDest])*(newYpos-monster[:yposDest]))/@mob_speed).to_i
        @monster_object[monster[:id]][:xpos] = monster[:xposDest]
        @monster_object[monster[:id]][:ypos] = monster[:yposDest]
        @monster_object[monster[:id]][:xposDest] = newXpos
        @monster_object[monster[:id]][:yposDest] = newYpos
        @monster_object[monster[:id]][:steps] = steps
        mob = {id: monster[:id], xpos: monster[:xpos], ypos: monster[:ypos], attacked: monster[:attacked],
        xposDest: newXpos, yposDest: newYpos, health: monster[:health], level:monster[:level], max_health:monster[:max_health]}
        WebsocketRails[:channel_name].trigger(:event_name, mob)
      else
        recalculateMobDestination(monster)  
      end
    end
    update_database
    check_monsters
  end
end