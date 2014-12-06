Sprint.Views.Maps ||= {}

class Sprint.Views.Maps.IndexView extends Backbone.View
  constructor: (options) ->
    this.configure(options || {})
    Backbone.View.prototype.constructor.apply(this, arguments)
  configure: (options) ->
    if (this.options) 
      options = _.extend({}, _.result(this, 'options'), options)
    this.options = options

  initialize: -> 
    self = this
    channel.bind('event_name', (data) ->
      self.get_all_mobs(data))					# websocket
    if move_on_count is 0
      @addAll()
      @game_init_function()
      
  addAll: () =>
    @options.monsters.each(@addOne)
  addOne: (monster) =>
    mob_list[monster.attributes.id] = monster.attributes 
    
  game_init_function: ->
    @ca = document.getElementById("maps")
    @ctx = @ca.getContext "2d"
    @move_on()
    
  get_all_mobs: (mob) ->
    mob_list[mob.id] = mob							# websocket
    reload_rate = web_refresh_time/1000
    mob_speed = 5*reload_rate
    steps = parseInt(Math.sqrt((mob.xposDest-mob.xpos)*(mob.xposDest-mob.xpos)+
    (mob.yposDest-mob.ypos)*(mob.yposDest-mob.ypos))/mob_speed)
    mob_list[mob.id].steps = steps
    
  fps = 40
  last_loop = new Date
  mob_list = []
  target_position = mouseX: 500, mouseY: 250
  this_position = mouseX: 480, mouseY: 240
  last_position = mouseX: 100, mouseY: 100
  player_steps = 10
  player_moving_speed = 3
  diffX = 40
  diffY = 20
  move_on = 1
  alfas = "true"
  checked_monster = cid: -1
  player_width = 10
  player_height = 10
  enemy_width = 20
  enemy_height = 20
  Xerror = 2
  Yerror = 3
  move_allowed = 1
  player_hp = 0
  enemy_hp = 0
  create_count = 0
  mob_units = 0
  mob_saving_number = 0
  move_on_count = 0
  attacking = -1
  attacking_allowed = true
  level = 0
  mspeed = 0.25
  web_refresh_time = 50 #milliseconds
  
  move_on: ->
    move_on_count++
    self = this
    timer web_refresh_time, ()-> self.checking_or_moved()
    timer 1000, ()-> self.mob_speed_to_FPS
    level = router.stats.models[0].attributes.level
    
  mob_speed_to_FPS: ->
    this_loop = new Date
    fps = parseInt(20000 / (this_loop - last_loop))+1
    mspeed = 0.25*(fps/20).toFixed(2)
    speed = 1*(fps/20).toFixed(2)
    last_loop = this_loop
   
  target_line: (width, height, rgba, mob) ->
    ctx = @ctx
    ctx.beginPath()
    ctx.lineWidth = 0.5
    ctx.lineCap = 'round'
    ctx.strokeStyle = rgba
    ctx.moveTo(mob.xpos+width/2,mob.ypos+height/2)
    ctx.lineTo(mob.xposDest+width/2,mob.yposDest+height/2)
    ctx.stroke()
    ctx.beginPath()
    ctx.strokeStyle = "red"
    ctx.arc(mob.xposDest+width/2,mob.yposDest+height/2,2,0,2*Math.PI)   
    ctx.stroke()
    
  checking_or_moved: ->
    @canvas()
    @player_movement()
    
  canvas: ->
    ctx = @ctx
    rect = @ca.getBoundingClientRect()
    @ctx.clearRect(rect.top, rect.left, 1500, 500)					# reset the canvas   
    player_steps -= 1
    @writing_levels_on_objects_and_health_bars()
    @recalculatePlayerTarget()			
    for mob in mob_list
      MobXpos = mob.xpos
      MobYpos = mob.ypos
      diff = mob.level - level											# lvl difference btw you and enemies.
      ctx.beginPath()
      if diff is 0															# If lvl difference is 0, enemy color is green
        ctx.fillStyle = 'green'
      if diff is -1
        ctx.fillStyle = 'green'
      if diff is -2															# If lvl difference is -2, enemie color is blue, etc..
        ctx.fillStyle = 'blue'
      if diff is -3
        ctx.fillStyle = 'blue'
      if diff is -4
        ctx.fillStyle = 'blue'
      if diff is -5
        ctx.fillStyle = 'blue'
      if diff is -6
        ctx.fillStyle = 'blue'
      if diff < -6
        ctx.fillStyle = 'gray'
      if diff is 1
        ctx.fillStyle = 'orange'
      if diff is 2
        ctx.fillStyle = 'orange'
      if diff is 3
        ctx.fillStyle = 'orange'
      if diff > 3
        ctx.fillStyle = 'red'
      ctx.fillRect(MobXpos, MobYpos, enemy_width, enemy_height)
      ctx.fillStyle = '#000000'
      ctx.font = '7px sans-serif'
      ctx.textBaseline = 'top'
      ctx.fillText(mob.level, MobXpos+enemy_width+2, MobYpos)
      
      @target_line(enemy_width, enemy_height, "rgba(32, 45, 21, 0.2)", mob)

      
      if mob.xpos is mob.xposDest and mob.ypos is mob.yposDest
        #console.log('mob reached target, waiting for new target from background')
      #else if attacking_allowed is false and attacking is mob.id
        #
      #else if attacking_allowed is true and attacking is mob.id
        #@respawn_mob(mob)
       # attacking = -1
       # attacking_allowed = false
      else
        @mob_start_moving(mob)
      mob_list[mob.id].steps -= 1
      
    @ctx.fillStyle="rgba(25,25,112,1)"										# the player color
    @ctx.fillRect(this_position.mouseX-player_width/2, \ 
      this_position.mouseY-player_height/2, \
      player_width, player_height)											# the player position
    @ctx.fillStyle = '#000000'
    @ctx.font = '7px sans-serif'
    @ctx.textBaseline = 'top'
    @ctx.fillText(level, this_position.mouseX+7, this_position.mouseY)
    player_object = {xpos: this_position.mouseX-player_width/2, ypos: this_position.mouseY-player_height/2,
    xposDest: target_position.mouseX-player_width/2, yposDest: target_position.mouseY-player_height/2}
    @target_line(player_width, player_height, "red", player_object)
        
    if move_allowed is 1
      @ctx.canvas.onmousemove = (evt) ->							# On every mouse move get the mouse position in map
        atcanvas = evt.target											# the  calculated mouse position is canvas area
        context = atcanvas.getContext('2d')
        mouseX  = evt.clientX-Xerror								# Mouse X position
        mouseY  = evt.clientY-Yerror								# Mouse Y position
        for mob in mob_list											# Array of all possible enemies in Map, which You can see
          mob_id = mob.id												
          Xpos = mob.xpos
          Ypos = mob.ypos					         
          								
          if mouseX > Xpos-enemy_width/2+Xerror*4 and mouseX< 
          Xpos+enemy_width/2+Xerror*4 and mouseY>
          Ypos-enemy_height/2+Yerror*2 and mouseY<
          Ypos+enemy_height/2+Yerror*4												# If this enemy is where the mouse Positions is
            atcanvas.style.cursor = 'pointer'									# Mouse image is "hand"
            context.canvas.onmousedown= () ->									# If the mouse Left button is Pressed
              target_position = mouseX: Xpos+
              enemy_width/2, mouseY: Ypos+enemy_height/2				      #  the position, so here You will move
              player_steps = parseInt(Math.sqrt((target_position.mouseX-this_position.mouseX)*
              (target_position.mouseX-this_position.mouseX)+(target_position.mouseY-this_position.mouseY)*
              (target_position.mouseY-this_position.mouseY))/(player_moving_speed*web_refresh_time/100))
              move_on = 1																# Start moving is Allowed
              checked_monster = cid: mob_id
            return    
        atcanvas.style.cursor = 'default'									# Now set mouse image to "Arrow" again, at every frame
        context.canvas.onmousedown= () ->									# If mouse is pressed anywhere on Map
          target_position = mouseX: mouseX, mouseY: mouseY				#  these X and Y positions
          player_steps = parseInt(Math.sqrt((target_position.mouseX-this_position.mouseX)*
          (target_position.mouseX-this_position.mouseX)+(target_position.mouseY-this_position.mouseY)*
          (target_position.mouseY-this_position.mouseY))/(player_moving_speed*web_refresh_time/100))
          move_on = 1																# Start moving is Allowed
          checked_monster = cid: -1											# Dont attack any monsters you did before
          return			

  player_movement: ->
    self = this   
    if router.stats.models[0].attributes.attack_allow is true
      move_allowed = 1
    if player_steps <= 0
      player_steps = 0
      move_on = 0																			# if yes, stop moving
      if checked_monster.cid > -1
        #@attack_monster(checked_monster.cid)
        move_allowed = 0
        attacking = checked_monster.cid
        checked_monster.cid = -1
        attacking_allowed = false

    if move_on is 1 and move_allowed is 1											# if it still not on destination							
      if alfas is "true"																# add extra debugger to not move buggy fast
        alfas = "false"																	
        self.calculating_destination()

  attack_monster: (cid) ->
    if router.stats.models[0].attributes.attack_allow is true
      attributes = mob_list[cid]
      router.send_monster_to_root(attributes)
      window.location.hash = "#/index"
      
  recalculatePlayerTarget: () ->
    if checked_monster.cid > -1
      target_position = mouseX: mob_list[checked_monster.cid].xpos+enemy_width/2, 
      mouseY: mob_list[checked_monster.cid].ypos+enemy_height/2
      player_steps = parseInt(Math.sqrt((target_position.mouseX-this_position.mouseX)*
      (target_position.mouseX-this_position.mouseX)+(target_position.mouseY-this_position.mouseY)*
      (target_position.mouseY-this_position.mouseY))/(player_moving_speed*web_refresh_time/100))
    
      
  recalculateMobDestination: (mob) ->
    Xpos = parseInt(mob.xpos)
    Ypos = parseInt(mob.ypos)
    newXpos = randomInt(Xpos-(spawn_radius), Xpos+(spawn_radius))
    newYpos = randomInt(Ypos-(spawn_radius), Ypos+(spawn_radius))  
    if 0 < newXpos < 1100 and 0 < newYpos < 380
      mob_list[mob.id].xposDest = newXpos
      mob_list[mob.id].yposDest = newYpos
    else
      @recalculateMobDestination(mob)
      
      
      
  save_mobs_position: ->
    for mob in mob_list
      @options.monsters.models[mob.id].save(level: mob.level+1,
       health: (mob.health+1)*25, yposDest: parseInt(mob.yposDest), xposDest: parseInt(mob.xposDest),
        ypos: parseInt(mob.ypos), xpos: parseInt(mob.xpos))
    
  respawn_mob: (mob) ->
    YposDest = randomInt(spawn_center.spawnY-(spawn_radius), spawn_center.spawnY+(spawn_radius))
    XposDest = randomInt(spawn_center.spawnX-(spawn_radius), spawn_center.spawnX+(spawn_radius)) 
    Ypos = randomInt(spawn_center.spawnY-(spawn_radius), spawn_center.spawnY+(spawn_radius))
    Xpos = randomInt(spawn_center.spawnX-(spawn_radius), spawn_center.spawnX+(spawn_radius))
    mob_list[mob.id].yposDest = YposDest
    mob_list[mob.id].xposDest = XposDest
    mob_list[mob.id].ypos = Ypos
    mob_list[mob.id].xpos = Xpos    
       
  set_attack_allowed: () ->
    attacking_allowed = true
    
      
  window.delay = (ms, fn)-> setTimeout(fn, ms)
  randomInt = (lower, upper) ->
    [lower, upper] = [0, lower]     unless upper?           # Called with one argument
    [lower, upper] = [upper, lower] if lower > upper        # Lower must be less then upper
    Math.floor(Math.random() * (upper - lower + 1) + lower) # Last statement is a return value
      
      

  writing_levels_on_objects_and_health_bars: ->  
    @ctx.fillStyle="red"
    @ctx.fillRect(5,335, 20, -(330*router.stats.models[0].attributes.player_hp/router.stats.models[0].attributes.max_hp))
    @ctx.fillRect(1075,335, 20, -(330*router.stats.models[0].attributes.monster_hp/router.stats.models[0].attributes.monster_max_hp))	

    @ctx.strokeStyle="black"
    @ctx.strokeRect(5,335, 20, -330)
    @ctx.strokeRect(1075,335, 20, -330)    

    @ctx.fillStyle = '#000000'
    @ctx.font = '20px sans-serif'
    @ctx.textBaseline = 'top'
    @ctx.fillText("Your HP", 5, 340)    
    @ctx.fillStyle = '#000000'
    @ctx.font = '20px sans-serif'
    @ctx.textBaseline = 'top'
    @ctx.fillText(router.stats.models[0].attributes.player_hp, 5, 360) 
    
    @ctx.fillStyle = '#000000'
    @ctx.font = '20px sans-serif'
    @ctx.textBaseline = 'top'
    @ctx.fillText("Enemy HP", 985, 340)
    @ctx.fillStyle = '#000000'
    @ctx.font = '20px sans-serif'
    @ctx.textBaseline = 'top'
    @ctx.fillText(router.stats.models[0].attributes.monster_hp, 985, 360)  
      
  calculating_destination: ->
    this_position.mouseX = (1-1/player_steps)*this_position.mouseX+1/player_steps*target_position.mouseX
    this_position.mouseY = (1-1/player_steps)*this_position.mouseY+1/player_steps*target_position.mouseY
    alfas = "true"		

  mob_start_moving: (mob) ->
    mob_list[mob.id].xpos = (1-1/mob.steps)*mob.xpos+1/mob.steps*mob.xposDest
    mob_list[mob.id].ypos = (1-1/mob.steps)*mob.ypos+1/mob.steps*mob.yposDest
      
  render: =>
    console.log("render", @options)


