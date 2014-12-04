class HardWorker
  include Sidekiq::Worker
  require 'sidekiq/api'
  
  def perform
    self.recalculate
  end
  
  def reset_database
    $redis.pipelined do
      (0...5).each do |mob_count|
        $redis.rpush "mobs", mob_count
        $redis.hset "mobs:#{mob_count}", 'id', "#{mob_count}"
        $redis.hset "mobs:#{mob_count}", 'xpos', 150
        $redis.hset "mobs:#{mob_count}", 'ypos', 125
        $redis.hset "mobs:#{mob_count}", 'xposDest', 175
        $redis.hset "mobs:#{mob_count}", 'yposDest', 150
        $redis.hset "mobs:#{mob_count}", 'level', "#{mob_count}"
        $redis.hset "mobs:#{mob_count}", 'health', "#{(mob_count*25)}"
      end
    end
  end
  
  def goga
    puts WebsocketRails
    mob = {id: 1, Xpos: 150, Ypos: 150, 
        XposDest: 170, YposDest: 170, level: 1, health: 25}
    WebsocketRails[:channel_name].trigger(:event_name, mob)
    puts "goga ended"
    
  end

  def recalculate
    monster_list = $redis.lrange('mobs', 0, -1)
    @monster_object= []
    @number = 0
    for monster in monster_list do
      id = ($redis.hget "mobs:#{monster}", 'id').to_i
      xpos = ($redis.hget "mobs:#{monster}", 'xpos').to_f
      ypos = ($redis.hget "mobs:#{monster}", 'ypos').to_f
      xposDest = ($redis.hget "mobs:#{monster}", 'xposDest').to_i
      yposDest = ($redis.hget "mobs:#{monster}", 'yposDest').to_i
      level = ($redis.hget "mobs:#{monster}", 'level').to_i
      health = ($redis.hget "mobs:#{monster}", 'health').to_i
      @monster_object[id] = {id: id, xpos: xpos, ypos: ypos, xposDest: xposDest, yposDest: yposDest, level:level, health:health}
      WebsocketRails[:channel_name].trigger(:event_name, @monster_object[id])
    end  
    
    def check_monsters
      (1..(2**(0.size * 8 -2) -1)).each do |number|
        for monster in @monster_object do
          x1 = monster[:xpos].to_i-2
          x2 = monster[:xpos].to_i+2
          y1 = monster[:ypos].to_i-2
          y2 = monster[:ypos].to_i+2
          if x1 <= monster[:xposDest] and monster[:xposDest] <= x2 and y1 <= monster[:yposDest] and monster[:yposDest] <= y2
            recalculateMobDestination(monster)
          else
            start_moving(monster)
          end
        end
        puts (number)
        sleep 0.1
      end
    end
    
    def recalculateMobDestination(monster)
      spawn_radius = 100
      newXpos = (sprintf '%.3f', (Random.new.rand((monster[:xpos]-spawn_radius)...(monster[:xpos]+spawn_radius)))).to_f
      newYpos = (sprintf '%.3f', (Random.new.rand((monster[:ypos]-spawn_radius)...(monster[:ypos]+spawn_radius)))).to_f  
      if 0 < newXpos &&  newXpos < 1100 && 0 < newYpos && newYpos < 380
        $redis.pipelined do
          $redis.hset "mobs:#{monster[:id]}", 'xpos', monster[:xpos]
          $redis.hset "mobs:#{monster[:id]}", 'ypos', monster[:ypos]
          $redis.hset "mobs:#{monster[:id]}", 'xposDest', newXpos
          $redis.hset "mobs:#{monster[:id]}", 'yposDest', newYpos
        end
        @monster_object[monster[:id]][:xposDest] = newXpos
        @monster_object[monster[:id]][:yposDest] = newYpos
        mob = {id: monster[:id], Xpos: monster[:xpos], Ypos: monster[:ypos], 
        XposDest: newXpos, YposDest: newYpos, level: monster[:level], health: monster[:health]}
        WebsocketRails[:channel_name].trigger(:event_name, mob)
      else
        recalculateMobDestination(monster)  
      end
    end
    
    def start_moving (monster)
      mspeed = 0.5
      xpos = (sprintf '%.3f', monster[:xpos]).to_f
      ypos = (sprintf '%.3f', monster[:ypos]).to_f
      mdiffY = monster[:yposDest]-ypos
      mdiffX = monster[:xposDest]-xpos
      mob_x_post = 0
      mob_y_post = 0
      if mdiffX > 0															
        if mdiffY > 0
          if mdiffX > mdiffY
            mob_x_post = xpos+mspeed
            mob_y_post = ypos+mdiffY/mdiffX*mspeed
          elsif mdiffX < mdiffY
            mob_x_post = xpos+mdiffX/mdiffY*mspeed
            mob_y_post = ypos+mspeed
          elsif mdiffX == mdiffY
            mob_x_post = xpos+mspeed
            mob_y_post = ypos+mspeed
          end
        elsif mdiffY < 0
          if mdiffX > -mdiffY
            mob_x_post = xpos+mspeed
            mob_y_post = ypos+mdiffY/mdiffX*mspeed
          elsif mdiffX < -mdiffY
            mob_x_post = xpos+mdiffX/(-mdiffY)*mspeed
            mob_y_post = ypos-mspeed
          elsif mdiffX == -mdiffY
            mob_x_post = xpos+mspeed
            mob_y_post = ypos-mspeed
          end
        end
      elsif mdiffX < 0
        if mdiffY > 0
          if -mdiffX > mdiffY
            mob_x_post = xpos-mspeed
            mob_y_post = ypos+mdiffY/(-mdiffX)*mspeed
          elsif -mdiffX < mdiffY
            mob_x_post = xpos+mdiffX/mdiffY*mspeed
            mob_y_post = ypos+mspeed
          elsif (-mdiffX) == mdiffY
            mob_x_post = xpos-mspeed
            mob_y_post = ypos+mspeed
          end
        elsif mdiffY < 0
          if -mdiffX > -mdiffY
            mob_x_post = xpos-mspeed
            mob_y_post = ypos-(-mdiffY)/(-mdiffX)*mspeed
          elsif -mdiffX < -mdiffY
            mob_x_post = xpos-(-mdiffX)/(-mdiffY)*mspeed
            mob_y_post = ypos-mspeed
          elsif (-mdiffX) == (-mdiffY)
            mob_x_post = xpos-mspeed
            mob_y_post = ypos-mspeed
          end
        end
      elsif mdiffX == 0
        if mdiffY > 0
          mob_x_post = xpos
          mob_y_post = ypos+mspeed
        elsif mdiffY < 0
          mob_x_post = xpos
          mob_y_post = ypos-mspeed
        elsif mdiffY == 0
          mob_x_post = xpos
          mob_y_post = ypos
        end
      elsif mdiffY == 0
        if mdiffX > 0
          mob_x_post = xpos+mspeed
          mob_y_post = ypos
        elsif mdiffX < 0 
          mob_x_post = xpos-mspeed
          mob_y_post = ypos
        elsif mdiffX == 0
          mob_x_post = xpos
          mob_y_post = ypos
        end
      end
      @monster_object[monster[:id]][:xpos] = (sprintf '%.3f', mob_x_post).to_f
      @monster_object[monster[:id]][:ypos] = (sprintf '%.3f', mob_y_post).to_f
    end
    
    check_monsters
  end
end