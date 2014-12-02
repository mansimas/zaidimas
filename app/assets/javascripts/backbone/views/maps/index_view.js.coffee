Sprint.Views.Maps ||= {}

class Sprint.Views.Maps.IndexView extends Backbone.View
  template: JST["backbone/templates/maps/index1"]
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
 
  game_init_function: ->
    @ca = document.getElementById("maps")
    @ctx = @ca.getContext "2d"
    @move_on()
    
  get_all_mobs: (mob) ->
    mob_list[mob.id] = mob
    console.log('mob updated')

  checking_or_moved: ->
   @canvas()
   @player_movement()
    
  fetch_mob: ()->
    for mob in mob_list
      console.log(mob)
    #@addAll()			# need only on init
    #@save_mobs_position()
    #@receiving_attributes_from_database()
    
  addAll: () =>
    @options.monsters.each(@addOne)

  addOne: (monster) =>
    mob_list[monster.attributes.id] = monster.attributes
    
  mob_list = []
  mobbys = []
  monster_Xspawn_center = 1: 100, 2: 300, 3: 500, 4: 700, 5: 900, 6: 150, 7: 350, 8: 550, 9: 750, 10: 950
  monster_Yspawn_center = 1: 100, 2: 100, 3: 100, 4: 100, 5: 100, 6: 300, 7: 300, 8: 300, 9: 300, 10: 300
  spawn_radius = 30
  monstersas = []
  enemy_count = []
  target_position = mouseX: 500, mouseY: 250
  this_position = mouseX: 480, mouseY: 240
  last_position = mouseX: 100, mouseY: 100
  diffX = 40
  diffY = 20
  speed = 1
  move_on = 1
  alfas = "true"
  checked_monster = cid: 0
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
  mob_x_pos = []
  mob_y_pos = []
  mob_x_post = []
  mob_y_post = []
  mob_x_posdest = []
  mob_y_posdest = [] 
  mob_saving_number = 0
  move_on_count = 0
  attacking = -1
  spawn_center = spawnX: 500, spawnY: 250
  attacking_allowed = true
  level = 0
  
  
  move_on: ->
    move_on_count++
    self = this
    timer 100, ()-> self.checking_or_moved()
    #timer 5000, ()-> self.fetch_mob()
    level = router.stats.models[0].attributes.level
    
  canvas: ->
    ctx = @ctx
    rect = @ca.getBoundingClientRect()
    @ctx.clearRect(rect.top, rect.left, 1500, 500)						# reset the canvas    
    @ctx.fillStyle="red"
    @ctx.fillRect(5,335, 20, -(330*router.stats.models[0].attributes.player_hp/router.stats.models[0].attributes.max_hp))
    @ctx.fillStyle="red"
    @ctx.fillRect(1075,335, 20, -(330*router.stats.models[0].attributes.monster_hp/router.stats.models[0].attributes.monster_max_hp))	

    @ctx.fillStyle="black"
    @ctx.strokeRect(5,335, 20, -330)
    @ctx.fillStyle="black"
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
    @recalculatePlayerTarget()			
    for mob in mob_list
      MobXpos = mob.Xpos
      MobYpos = mob.Ypos
      diff = mob.level - level											# lvl difference btw you and enemies.
      ctx.beginPath()
      if diff is 0																# If lvl difference is 0, enemy color is green
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
      #enemy_count.push Xpos:MobXpos, Ypos:MobYpos, cid:mob.id
      if mob.Xpos is mob.XposDest and mob.Ypos is mob.YposDest
        console.log('mob reached target, waiting for new target from background')
      #else if attacking_allowed is false and attacking is mob.id
        #
      #else if attacking_allowed is true and attacking is mob.id
        #@respawn_mob(mob)
       # attacking = -1
       # attacking_allowed = false
      else
        @mob_start_moving(mob)
      
      
    @ctx.fillStyle="rgba(25,25,112,1)"										# the player color
    @ctx.fillRect(this_position.mouseX-player_width/2, \ 
      this_position.mouseY-player_height/2, \
      player_width, player_height)											# the player position
    @ctx.fillStyle = '#000000'
    @ctx.font = '7px sans-serif'
    @ctx.textBaseline = 'top'
    @ctx.fillText(level, this_position.mouseX+7, this_position.mouseY)
        
    if move_allowed is 1
      @ctx.canvas.onmousemove = (evt) ->										# On every mouse move get the mouse position in map
        atcanvas = evt.target													# the  calculated mouse position is canvas area
        context = atcanvas.getContext('2d')
        mouseX  = evt.clientX-Xerror											# Mouse X position
        mouseY  = evt.clientY-Yerror											# Mouse Y position
        for mob in mob_list											# Array of all possible enemies in Map, which You can see
          mob_id = mob.id												
          Xpos = mob.Xpos
          Ypos = mob.Ypos					         
          								
          if mouseX > Xpos-enemy_width/2+Xerror*4 and mouseX< 
          Xpos+enemy_width/2+Xerror*4 and mouseY>
          Ypos-enemy_height/2+Yerror*2 and mouseY<
          Ypos+enemy_height/2+Yerror*4											# If this enemy is where the mouse Positions is
            atcanvas.style.cursor = 'pointer'									# Mouse image is "hand"
            context.canvas.onmousedown= () ->									# If the mouse Left button is Pressed
              target_position = mouseX: Xpos+
              enemy_width/2, mouseY: Ypos+enemy_height/2				      #  the position, so here You will move
              diffX = target_position.mouseX - this_position.mouseX			# Calculate the X-difference between You and enemy
              diffY = target_position.mouseY - this_position.mouseY			# Calculate the Y-difference between You and enemy
              move_on = 1																	# Start moving is Allowed
              checked_monster = cid: mob_id
            return    
        atcanvas.style.cursor = 'default'									# Now set mouse image to "Arrow" again, at every frame
        context.canvas.onmousedown= () ->									# If mouse is pressed anywhere on Map
          target_position = mouseX: mouseX, mouseY: mouseY					#  these X and Y positions
          diffX = target_position.mouseX - this_position.mouseX			# calculate the X position difference
          diffY = target_position.mouseY - this_position.mouseY			# calculate the Y position difference
          move_on = 1																	# Start moving is Allowed
          checked_monster = cid: -1											# Dont attack any monsters you did before
          return			

  calculating_destination: ->
    last_position = this_position													# restore the new position of player
    if diffX > 0															
      if diffY > 0
        if diffX > diffY
          this_position = mouseX: this_position.mouseX+speed, mouseY: this_position.mouseY+diffY/diffX*speed
        if diffX < diffY
          this_position = mouseX: this_position.mouseX+diffX/diffY*speed, mouseY: this_position.mouseY+speed
        if diffX is diffY
          this_position = mouseX: this_position.mouseX+speed, mouseY: this_position.mouseY+speed
      if diffY < 0
        if diffX > -diffY
          this_position = mouseX: this_position.mouseX+speed, mouseY: this_position.mouseY+diffY/diffX*speed
        if diffX < -diffY
          this_position = mouseX: this_position.mouseX+diffX/(-diffY)*speed, mouseY: this_position.mouseY-speed
        if diffX is -diffY
          this_position = mouseX: this_position.mouseX+speed, mouseY: this_position.mouseY-speed
          
    if diffX < 0
      if diffY > 0
        if -diffX > diffY
          this_position = mouseX: this_position.mouseX-speed, mouseY: this_position.mouseY+diffY/(-diffX)*speed
        if -diffX < diffY
          this_position = mouseX: this_position.mouseX+diffX/diffY*speed, mouseY: this_position.mouseY+speed
        if -diffX is diffY
          this_position = mouseX: this_position.mouseX-speed, mouseY: this_position.mouseY+speed
      if diffY < 0
        if -diffX > -diffY
          this_position = mouseX: this_position.mouseX-speed, mouseY: this_position.mouseY-(-diffY)/(-diffX)*speed
        if -diffX < -diffY
          this_position = mouseX: this_position.mouseX-(-diffX)/(-diffY)*speed, mouseY: this_position.mouseY-speed
        if -diffX is -diffY
          this_position = mouseX: this_position.mouseX-speed, mouseY: this_position.mouseY-speed
          
    if diffX is 0
      if diffY > 0
        this_position = mouseX: this_position.mouseX, mouseY: this_position.mouseY+speed
      if diffY < 0
        this_position = mouseX: this_position.mouseX, mouseY: this_position.mouseY-speed
      if diffY is 0
        this_position = mouseX: this_position.mouseX, mouseY: this_position.mouseY
        
    if diffY is 0
      if diffX > 0
        this_position = mouseX: this_position.mouseX+speed, mouseY: this_position.mouseY
      if diffX < 0
        this_position = mouseX: this_position.mouseX-speed, mouseY: this_position.mouseY
      if diffX is 0
        this_position = mouseX: this_position.mouseX, mouseY: this_position.mouseY
    alfas = "true"		
    
  mob_start_moving: (mob) ->
    id = mob.id
    mspeed = 0.5
    Ypos = mob.Ypos
    Xpos = mob.Xpos
    mdiffY = mob.YposDest-Ypos
    mdiffX = mob.XposDest-Xpos
    if mdiffX > 0															
      if mdiffY > 0
        if mdiffX > mdiffY
          mob_list[id].Xpos = Xpos+mspeed
          mob_list[id].Ypos = Ypos+mdiffY/mdiffX*mspeed
        if mdiffX < mdiffY
          mob_list[id].Xpos = Xpos+mdiffX/mdiffY*mspeed
          mob_list[id].Ypos = Ypos+mspeed
        if mdiffX is mdiffY
          mob_list[id].Xpos = Xpos+mspeed
          mob_list[id].Ypos = Ypos+mspeed
      if mdiffY < 0
        if mdiffX > -mdiffY
          mob_list[id].Xpos = Xpos+mspeed
          mob_list[id].Ypos = Ypos+mdiffY/mdiffX*mspeed
        if mdiffX < -mdiffY
          mob_list[id].Xpos = Xpos+mdiffX/(-mdiffY)*mspeed
          mob_list[id].Ypos = Ypos-mspeed
        if mdiffX is -mdiffY
          mob_list[id].Xpos = Xpos+mspeed
          mob_list[id].Ypos = Ypos-mspeed
          
    if mdiffX < 0
      if mdiffY > 0
        if -mdiffX > mdiffY
          mob_list[id].Xpos = Xpos-mspeed
          mob_list[id].Ypos = Ypos+mdiffY/(-mdiffX)*mspeed
        if -mdiffX < mdiffY
          mob_list[id].Xpos = Xpos+mdiffX/mdiffY*mspeed
          mob_list[id].Ypos = Ypos+mspeed
        if -mdiffX is mdiffY
          mob_list[id].Xpos = Xpos-mspeed
          mob_list[id].Ypos = Ypos+mspeed
      if mdiffY < 0
        if -mdiffX > -mdiffY
          mob_list[id].Xpos = Xpos-mspeed
          mob_list[id].Ypos = Ypos-(-mdiffY)/(-mdiffX)*mspeed
        if -mdiffX < -mdiffY
          mob_list[id].Xpos = Xpos-(-mdiffX)/(-mdiffY)*mspeed
          mob_list[id].Ypos = Ypos-mspeed
        if -mdiffX is -mdiffY
          mob_list[id].Xpos = Xpos-mspeed
          mob_list[id].Ypos = Ypos-mspeed
          
    if mdiffX is 0
      if mdiffY > 0
        mob_list[id].Xpos = Xpos
        mob_list[id].Ypos = Ypos+mspeed
      if mdiffY < 0
        mob_list[id].Xpos = Xpos
        mob_list[id].Ypos = Ypos-mspeed
      if mdiffY is 0
        mob_list[id].Xpos = Xpos
        mob_list[id].Ypos = Ypos
        
    if mdiffY is 0
      if mdiffX > 0
        mob_list[id].Xpos = Xpos+mspeed
        mob_list[id].Ypos = Ypos
      if mdiffX < 0
        mob_list[id].Xpos = Xpos-mspeed
        mob_list[id].Ypos = Ypos
      if mdiffX is 0
        mob_list[id].Xpos = Xpos
        mob_list[id].Ypos = Ypos
    
  player_movement: ->
    self = this   
    if router.stats.models[0].attributes.attack_allow is true
      move_allowed = 1
    if target_position.mouseX > this_position.mouseX-player_width/20 \	
    and target_position.mouseX < this_position.mouseX+player_width/20 \
    and target_position.mouseY > this_position.mouseY-player_height/20 \
    and target_position.mouseY < this_position.mouseY+player_height/20	# calculate or player reached the destination centre
      move_on = 0																			# if yes, stop moving
      if checked_monster.cid > -1
        #@attack_monster(checked_monster.cid)
        move_allowed = 0
        attacking = checked_monster.cid
        checked_monster.cid = -1
        attacking_allowed = false

    if move_on is 1 and move_allowed is 1																		# if it still not on destination							
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
      diffX = target_position.mouseX - this_position.mouseX
      diffY = target_position.mouseY - this_position.mouseY
      target_position = mouseX: mob_list[checked_monster.cid].Xpos+enemy_width/2, mouseY: mob_list[checked_monster.cid].Ypos+enemy_height/2
    
      
  recalculateMobDestination: (mob) ->
    Xpos = parseInt(mob.Xpos)
    Ypos = parseInt(mob.Ypos)
    newXpos = randomInt(Xpos-(spawn_radius), Xpos+(spawn_radius))
    newYpos = randomInt(Ypos-(spawn_radius), Ypos+(spawn_radius))  
    if 0 < newXpos < 1100 and 0 < newYpos < 380
      mob_list[mob.id].XposDest = newXpos
      mob_list[mob.id].YposDest = newYpos
    else
      @recalculateMobDestination(mob)
      
      
      
  save_mobs_position: ->
    for mob in mob_list
      @options.monsters.models[mob.id].save(level: mob.level+1,
       health: (mob.health+1)*25, YposDest: parseInt(mob.YposDest), XposDest: parseInt(mob.XposDest),
        Ypos: parseInt(mob.Ypos), Xpos: parseInt(mob.Xpos))
    
  respawn_mob: (mob) ->
    YposDest = randomInt(spawn_center.spawnY-(spawn_radius), spawn_center.spawnY+(spawn_radius))
    XposDest = randomInt(spawn_center.spawnX-(spawn_radius), spawn_center.spawnX+(spawn_radius)) 
    Ypos = randomInt(spawn_center.spawnY-(spawn_radius), spawn_center.spawnY+(spawn_radius))
    Xpos = randomInt(spawn_center.spawnX-(spawn_radius), spawn_center.spawnX+(spawn_radius))
    mob_list[mob.id].YposDest = YposDest
    mob_list[mob.id].XposDest = XposDest
    mob_list[mob.id].Ypos = Ypos
    mob_list[mob.id].Xpos = Xpos    
       
  set_attack_allowed: () ->
    attacking_allowed = true
    
      
  window.delay = (ms, fn)-> setTimeout(fn, ms)
  randomInt = (lower, upper) ->
    [lower, upper] = [0, lower]     unless upper?           # Called with one argument
    [lower, upper] = [upper, lower] if lower > upper        # Lower must be less then upper
    Math.floor(Math.random() * (upper - lower + 1) + lower) # Last statement is a return value
      
      
  render: =>
    console.log("render", @options)

