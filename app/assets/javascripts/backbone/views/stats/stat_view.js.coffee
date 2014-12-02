Sprint.Views.Stats ||= {}

class Sprint.Views.Stats.StatView extends Backbone.View
  template: JST["backbone/templates/stats/stat"]
  initialize: ->
    @listenTo @model, 'change', @render
    #@model.check_attributes()
    @attack_allowing()
    #@exp_left()
    #@model.set_totals()
    @model.set(monster_hp: monster_hp, monster_max_hp: monster_hp)

  monster_name= null
  monster_level= 0
  monster_hp= 0
  monster_exp= 0
  monster_money= 0
  monster_min_dmg= 0
  monster_max_dmg= 0
  monster_speed= 0
  monster_speen_in_fight= 0
  monster_agility= 0
  monster_defence= 0
  monster_critical= 0
  monster_critical_multiplier= 0
  monster_evasion= 0
  monster_accuracy= 0
  monster_id= 0
  monster_rang = 0
  medicine_using = 30
  found_item = []


  events:
    "click .add_health" : "add_health"
    "click .add_strength" : "add_strength"
    "click .add_agility" : "add_agility"
    "click .remove_weapon" : "remove_weapon"
    "click .remove_armor" : "remove_armor"
    "click .remove_gloves" : "remove_gloves"
    "click .remove_shoes" : "remove_shoes"
    "click .remove_helmet" : "remove_helmet"
    "click .upgrade_weapon" : "upgrade_weapon"
    "click .upgrade_armor" : "upgrade_armor"
    "click .upgrade_gloves" : "upgrade_gloves"
    "click .upgrade_shoes" : "upgrade_shoes"
    "click .upgrade_helmet" : "upgrade_helmet"
    "click .level_up" : "exp_stats"



  randomInt = (lower, upper) ->
    [lower, upper] = [0, lower]     unless upper?           # Called with one argument
    [lower, upper] = [upper, lower] if lower > upper        # Lower must be less then upper
    Math.floor(Math.random() * (upper - lower + 1) + lower) # Last statement is a return value

  window.delay = (ms, fn)-> setTimeout(fn, ms)
  window.timer = (ms, fn)-> setInterval(fn, ms)
    
   
  attack_allowing: ->
    self = this
    delay 500, ()-> self.model.set(attack_allow: true)




  add_health: (e) ->
    e.preventDefault()
    if @model.attributes.stat > 0
      @model.set(stat: @model.attributes.stat-1, health: @model.attributes.health+1)
    @model.save()
    @model.set_totals()

  add_strength: (e) ->
    e.preventDefault()
    if @model.attributes.stat > 0
      @model.set(stat: @model.attributes.stat-1, strength: @model.attributes.strength+1)
    @model.save()
    @model.set_totals()

  use_this_item: (attributes) ->
    if attributes.itemname is "weapon"
      @model.set(weapon_name: attributes.item, weapon_user_id: attributes.user_id, weapon_strength: attributes.strength, weapon_health:attributes.health, weapon_agility: attributes.agility, weapon_level: attributes.level, weapon_defence: attributes.defence, weapon_itemname: attributes.itemname, weapon_money: attributes.money, weapon_grade: attributes.grade)
    if attributes.itemname is "armor"
      @model.set(armor_name: attributes.item, armor_user_id: attributes.user_id, armor_strength: attributes.strength, armor_health:attributes.health, armor_agility: attributes.agility, armor_level: attributes.level, armor_defence: attributes.defence, armor_itemname: attributes.itemname, armor_money: attributes.money, armor_grade: attributes.grade)
    if attributes.itemname is "gloves"
      @model.set(gloves_name: attributes.item, gloves_user_id: attributes.user_id, gloves_strength: attributes.strength, gloves_health:attributes.health, gloves_agility: attributes.agility, gloves_level: attributes.level, gloves_defence: attributes.defence, gloves_itemname: attributes.itemname, gloves_money: attributes.money, gloves_grade: attributes.grade)
    if attributes.itemname is "shoes"
      @model.set(shoes_name: attributes.item, shoes_user_id: attributes.user_id, shoes_strength: attributes.strength, shoes_health:attributes.health, shoes_agility: attributes.agility, shoes_level: attributes.level, shoes_defence: attributes.defence, shoes_itemname: attributes.itemname, shoes_money: attributes.money, shoes_grade: attributes.grade)
    if attributes.itemname is "helmet"
      @model.set(helmet_name: attributes.item, helmet_user_id: attributes.user_id, helmet_strength: attributes.strength, helmet_health:attributes.health, helmet_agility: attributes.agility, helmet_level: attributes.level, helmet_defence: attributes.defence, helmet_itemname: attributes.itemname, helmet_money: attributes.money, helmet_grade: attributes.grade)
    @model.save()
    @model.set_totals()

  sell_item: (attributes) ->
    moneymoney = parseInt(@model.attributes.money) + parseInt(attributes.level*attributes.money)
    @model.set(money: moneymoney)

  buy_item: (attributes) ->
    moneymoney = parseInt(@model.attributes.money) - parseInt(attributes.price)
    @model.set(money: moneymoney)
    

  add_agility: (e) ->
    e.preventDefault()
    if @model.attributes.stat > 0
      @model.set(stat: @model.attributes.stat-1, agility: @model.attributes.agility+1)
    @model.save()
    @model.set_totals()

  start_attacking_monster: ->
    self = this
    player_speed = 3000-parseInt(@model.attributes.speed)
    delay player_speed, ()-> self.successfully_attacked_monster()

  start_attacking_player: ->
    self = this
    monster_speed_in_fight = 3000-parseInt(monster_speed)
    delay monster_speed_in_fight, ()-> self.successfully_attacked_player()

  player_text = ""
  successfully_attacked_monster: ->
    succeed_critical_hit = @model.attributes.critical - randomInt(1,100)
    if monster_hp > 0
      if succeed_critical_hit >= 0
        dealt_dmg_of_player = ((randomInt(@model.attributes.min_dmg , @model.attributes.max_dmg))*@model.attributes.critical_multiplier)-monster_defence
      if succeed_critical_hit < 0
        dealt_dmg_of_player = randomInt(@model.attributes.min_dmg , @model.attributes.max_dmg)-monster_defence
      if @model.attributes.player_hp >= 0
        if dealt_dmg_of_player <= 0
          dealt_dmg_of_player = 1
        monster_hp= monster_hp - dealt_dmg_of_player
        @model.set(monster_hp: monster_hp)
        if succeed_critical_hit >= 0
          player_text_helper = "You made <span style='color:red'>critical</span> " + dealt_dmg_of_player + " dmg, " + monster_name + " has " + monster_hp + " Hp"
        if succeed_critical_hit < 0
          player_text_helper = "You made " + dealt_dmg_of_player + " dmg, " + monster_name + " has " + monster_hp + " Hp"
        if monster_hp <= 0
          monster_hp= 0
          @model.set(monster_hp: monster_hp, experience: @model.attributes.experience+monster_exp, mobs_killed: parseInt(@model.attributes.mobs_killed+1))
          drop_random_number = randomInt(1,(8-parseInt(monster_rang)+@model.attributes.level))
          if drop_random_number > 7
            if monster_level < 10
              @model.set(medicine1: @model.attributes.medicine1+1)
              found_item = itemname: "medicine1", name: "tiny medicine"
            if monster_level >= 10 and monster_level < 20
              @model.set(medicine2: @model.attributes.medicine2+1)
              found_item = itemname: "medicine2", name: "small medicine"
            if monster_level >= 20 and monster_level < 30
              @model.set(medicine3: @model.attributes.medicine3+1)
              found_item = itemname: "medicine3", name: "medium medicine"
            if monster_level >= 30 and monster_level < 40
              @model.set(medicine4: @model.attributes.medicine4+1)
              found_item = itemname: "medicine4", name: "big medicine"
            if monster_level >= 40 and monster_level < 50
              @model.set(medicine5: @model.attributes.medicine5+1)
              found_item = itemname: "medicine5", name: "very big medicine"
            if monster_level >= 50 and monster_level < 60
              @model.set(medicine6: @model.attributes.medicine6+1)
              found_item = itemname: "medicine6", name: "huge medicine"
            if monster_level >= 60 and monster_level < 70
              @model.set(medicine7: @model.attributes.medicine7+1)
              found_item = itemname: "medicine7", name: "very huge medicine"
            if monster_level >= 70 and monster_level < 80
              @model.set(medicine8: @model.attributes.medicine8+1)
              found_item = itemname: "medicine8", name: "insane medicine"
            if monster_level >= 80 and monster_level < 90
              @model.set(medicine9: @model.attributes.medicine9+1)
              found_item = itemname: "medicine9", name: "very insane medicine"
            if monster_level >= 90
              @model.set(medicine10: @model.attributes.medicine10+1)
              found_item = itemname: "medicine10", name: "super medicine"
          if drop_random_number <= 7
            money_drop = randomInt(1,(11-parseInt(monster_rang)))
            if money_drop > 7
              moneymoney = parseInt(@model.attributes.money)+parseInt(monster_level*monster_rang)
              @model.set(money: moneymoney)
              found_item = itemname: "gold", name: "gold", money:monster_money*monster_rang
            if money_drop <= 7
              @get_items_from_killed_monster()
          @model.save()
          if succeed_critical_hit >= 0
            if found_item.name is "gold"
              player_text_helper = "You made <span style='color:red'>critical</span> " + dealt_dmg_of_player + " dmg, " + monster_name + " died.<br>" + " You won! Your reward is " + monster_exp + " exp<br>You found "+ monster_money+" money!"
            else
              player_text_helper = "You made <span style='color:red'>critical</span> " + dealt_dmg_of_player + " dmg, " + monster_name + " died.<br>" + " You won! Your reward is " + monster_exp + " exp <br>You found "+found_item.name
          if succeed_critical_hit < 0
            if found_item.name is "gold"
              player_text_helper = "You made " + dealt_dmg_of_player + " dmg, " + monster_name + " died<br>" + " You won! Your reward is " + monster_exp + " exp<br>You found " + monster_money + " money!"
            else
              player_text_helper = "You made " + dealt_dmg_of_player + " dmg, " + monster_name + " died<br>" + " You won! Your reward is " + monster_exp + " exp <br>You found "+found_item.name
          @attack_allowing()
          router.set_attack_allowed()
        $("#text").html(player_text + player_text_helper)
        player_text = player_text + player_text_helper + "<br>"
        $("#text").scrollTop($("#text").prop("scrollHeight"))
        @start_attacking_monster()

  monster_text = ""
  successfully_attacked_player: ->
    succeed_critical_hit = monster_critical - randomInt(1,100)
    if monster_hp > 0
      if succeed_critical_hit >= 0
        dealt_dmg_of_monster = ((randomInt(monster_min_dmg , monster_max_dmg))*monster_critical_multiplier)-@model.attributes.total_defence
      if succeed_critical_hit < 0
        dealt_dmg_of_monster = randomInt(monster_min_dmg , monster_max_dmg)-@model.attributes.total_defence
      if @model.attributes.player_hp >= 0
        if dealt_dmg_of_monster <= 0
          dealt_dmg_of_monster = 1
        @model.set(player_hp: @model.attributes.player_hp - dealt_dmg_of_monster)
        @model.save()
        if succeed_critical_hit >= 0
          monster_text_helper = monster_name + " made <span style='color:red'>critical</span> " + dealt_dmg_of_monster + " dmg, you have " + @model.attributes.player_hp + " Hp"
        if succeed_critical_hit < 0
          monster_text_helper = monster_name + " made " + dealt_dmg_of_monster + " dmg, you have " + @model.attributes.player_hp + " Hp"
        if @model.attributes.player_hp <= 0
          @model.set(player_hp: 0)
          @model.save()
          if succeed_critical_hit >= 0
            monster_text_helper = monster_name + " made <span style='color:red'>critical</span> " + dealt_dmg_of_monster + " dmg, you have 0 Hp<br>You died! "
          if succeed_critical_hit < 0
            monster_text_helper = monster_name + " made " + dealt_dmg_of_monster + " dmg, you have 0 Hp<br>You died! "
          monster_hp= 0
          @attack_allowing()
        $("#text1").html(monster_text + monster_text_helper)
        $("#text1").scrollTop($("#text1").prop("scrollHeight"))
        monster_text = monster_text + monster_text_helper + "<br>"
        @start_attacking_player()

  attack_monster: (attributes) ->
    if @model.attributes.attack_allow is true and @model.attributes.player_hp > (@model.attributes.max_hp/10)
      @model.set(attack_allow: false)
      player_text = ""
      monster_text = ""
      self = this
      player = @model.attributes
      enemy_level = attributes.level
      diff = enemy_level - player.level
      this_exp = 0
      if diff is 0
        this_exp = attributes.experience
      if diff is -1
        this_exp = attributes.experience
      if diff is -2
        this_exp = attributes.experience-(attributes.experience/100*50)
      if diff is -3
        this_exp = attributes.experience-(attributes.experience/100*50)
      if diff is -4
        this_exp = attributes.experience-(attributes.experience/100*50)
      if diff is -5
        this_exp = attributes.experience-(attributes.experience/100*50)
      if diff is -6
        this_exp = attributes.experience-(attributes.experience/100*50)
      if diff < -6
        this_exp = 1
      if diff is 1
        this_exp = attributes.experience+(attributes.experience/100*50)
      if diff is 2
        this_exp = attributes.experience+(attributes.experience/100*50)
      if diff is 3
        this_exp = attributes.experience+(attributes.experience/100*50)
      if diff > 3
        this_exp = attributes.experience*2
      
      
      if (attributes.user_id?)
        monster_rang= 0
        monster_level= attributes.level
        monster_id= attributes.id
        monster_name= attributes.username
        monster_hp= attributes.player_hp
        monster_exp= this_exp
        monster_money= parseInt(attributes.money/100)
        monster_min_dmg= attributes.min_dmg
        monster_max_dmg= attributes.max_dmg
        monster_speed= attributes.speed
        monster_defence= attributes.defence
        monster_critical= attributes.critical
        monster_critical_multiplier= attributes.critical_multiplier
      else
        @model.set(monster_max_hp: attributes.health)
        monster_rang= attributes.rang
        monster_level= attributes.level
        monster_id= attributes.id
        monster_name= attributes.name
        monster_hp= attributes.health
        monster_exp= this_exp
        monster_money= attributes.money
        monster_min_dmg= attributes.min_dmg
        monster_max_dmg= attributes.max_dmg
        monster_speed= attributes.speed
        monster_defence= attributes.defence
        monster_critical= attributes.critical
        monster_critical_multiplier= attributes.critical_multiplier
      delay 100, ()-> self.start_attacking_monster()
      delay 100, ()-> self.start_attacking_player()
      @show_enemie()

  show_enemie: ->
    $("#text2").html("Your enemy stats: <br>name: "+monster_name+"<br>rank: "+monster_rang+"<br>hp: "+monster_hp+"<br>damage: "+monster_min_dmg+"~"+monster_max_dmg+"<br>speed: "+monster_speed+"<br>defence: "+monster_defence+"<br>critical: "+monster_critical+"%<br>critical multiplier: "+monster_critical_multiplier+"<br>you get exp: "+monster_exp+"<br>you get money: "+parseInt(monster_money))
    
  level = []
  level[0] = exp: 0
  level[1] = exp: 5
  level[2] = exp: 24
  level[3] = exp: 60
  level[4] = exp: 80
  level[5] = exp: 164
  level[6] = exp: 271
  level[7] = exp: 407
  level[8] = exp: 579
  level[9] = exp: 794
  level[10] = exp: 1125
  level[11] = exp: 1543
  level[12] = exp: 2068
  level[13] = exp: 2722
  level[14] = exp: 3534
  level[15] = exp: 4563
  level[16] = exp: 5830
  level[17] = exp: 7385
  level[18] = exp: 9286
  level[19] = exp: 11607
  level[20] = exp: 17497
  level[21] = exp: 21845
  level[22] = exp: 27147
  level[23] = exp: 33593
  level[24] = exp: 41416
  level[25] = exp: 51341
  level[26] = exp: 63394
  level[27] = exp: 78005
  level[28] = exp: 95696
  level[29] = exp: 117090
  level[30] = exp: 166758
  level[31] = exp: 203151
  level[32] = exp: 247043
  level[33] = exp: 299942
  level[34] = exp: 363659
  level[35] = exp: 440404
  level[36] = exp: 532757
  level[37] = exp: 643849
  level[38] = exp: 777437
  level[39] = exp: 938032
  level[40] = exp: 1211834
  level[41] = exp: 1460324
  level[42] = exp: 1758856
  level[43] = exp: 2117449
  level[44] = exp: 2548126
  level[45] = exp: 3065315
  level[46] = exp: 3686331
  level[47] = exp: 4431950
  level[48] = exp: 5327106
  level[49] = exp: 6401717
  level[50] = exp: 10255633
  level[51] = exp: 12320243
  level[52] = exp: 14798389
  level[53] = exp: 17772795
  level[54] = exp: 21342730
  level[55] = exp: 25627317
  level[56] = exp: 30769501
  level[57] = exp: 36940820
  level[58] = exp: 44347118
  level[59] = exp: 53235407
  level[60] = exp: 63902104
  level[61] = exp: 76702906
 
  exp_left: ->
    a = @model.attributes.level
    @model.set(exp_left: level[a].exp+1)
    @model.save()

  lvlup: -> 
    a = @model.attributes.level
    @model.set(level: @model.attributes.level+1, stat: @model.attributes.stat+5, experience: @model.attributes.experience-level[a].exp, player_hp: @model.attributes.max_hp)  
    @model.save()
    @exp_left()
    router.render_maps()

  exp_stats: ->
    a = @model.attributes.level
    if level[a].exp < @model.attributes.experience
      @lvlup()

  get_items_from_killed_monster: ->
    item = []

    item[11] = itemname: "weapon", money: 3,  name: "<span style='font-weight:bold;color:gray;'>weak weapon</span>", strength: 1*monster_level, health: 1*monster_level, agility: 0,  level: monster_level, defence: 0, grade: 1
    item[12] = itemname: "armor",money: 2, name: "<span style='font-weight:bold;color:gray;'>weak armor</span>", strength: 0, health: 1*monster_level, agility: 0,  level: monster_level, defence: 1*monster_level, grade: 1
    item[13] = itemname: "gloves", money: 1,name: "<span style='font-weight:bold;color:gray;'>weak gloves</span>", strength: 0, health: 1*monster_level, agility: 0,  level: monster_level, defence: 0, grade: 1
    item[14] = itemname: "shoes", money: 1,name: "<span style='font-weight:bold;color:gray;'>weak shoes</span>", strength: 0, health: 0, agility: 1*monster_level,  level: monster_level, defence: 0, grade: 1
    item[15] = itemname: "helmet",money: 1, name: "<span style='font-weight:bold;color:gray;'>weak helmet</span>" , strength: 0, health: 0, agility: 0,  level: monster_level, defence: 1*monster_level, grade: 1

    item[16] = itemname: "weapon",money: 15, name: "<span style='font-weight:bold;color:green;'>normal weapon</span>", strength: 2*monster_level, health: 2*monster_level, agility: 0,  level: monster_level, defence: 0, grade: 1
    item[17] = itemname: "armor",money:10, name: "<span style='font-weight:bold;color:green;'>normal armor</span>", strength: 0, health: 2*monster_level, agility: 0, level: monster_level, defence: 2*monster_level, grade: 1
    item[18] = itemname: "gloves",money: 5, name: "<span style='font-weight:bold;color:green;'>normal gloves</span>", strength: 0, health: 2*monster_level, agility: 1*monster_level,  level: monster_level, defence: 0, grade: 1
    item[19] = itemname: "shoes",money: 5, name: "<span style='font-weight:bold;color:green;'>normal shoes</span>", strength: 0, health: 1*monster_level, agility: 2*monster_level, level: monster_level, defence: 0, grade: 1
    item[20] = itemname: "helmet",money: 5, name: "<span style='font-weight:bold;color:green;'>normal helmet</span>", strength: 0, health: 0, agility: 1*monster_level,level: monster_level, defence: 2*monster_level, grade: 1

    item[21] = itemname: "weapon",money: 50, name: "<span style='font-weight:bold;color:blue;'>good weapon</span>", strength: 3*monster_level, health: 3*monster_level, agility: 0,  level: monster_level, defence: 0, grade: 1
    item[22] = itemname: "armor",money: 30, name: "<span style='font-weight:bold;color:blue;'>good armor</span>", strength: 1*monster_level, health: 3*monster_level, agility: 1*monster_level,  level: monster_level, defence: 3*monster_level, grade: 1
    item[23] = itemname: "gloves",money: 15, name: "<span style='font-weight:bold;color:blue;'>good gloves</span>", strength: 0, health: 3*monster_level, agility: 2*monster_level, level: monster_level, defence: 1*monster_level, grade: 1
    item[24] = itemname: "shoes",money: 15, name: "<span style='font-weight:bold;color:blue;'>good shoes</span>", strength: 0, health: 2*monster_level, agility: 3*monster_level,  level: monster_level, defence: 0, grade: 1
    item[25] = itemname: "helmet",money: 15, name: "<span style='font-weight:bold;color:blue;'>good helmet</span>", strength: 0, health: 0, agility: 2*monster_level,  level: monster_level, defence: 3*monster_level, grade: 1

    item[26] = itemname: "weapon",money: 150, name: "<span style='font-weight:bold;color:purple;'>very good weapon</span>", strength: 4*monster_level, health: 4*monster_level, agility: 0, level: monster_level, defence: 0, grade: 1
    item[27] = itemname: "armor",money: 100, name: "<span style='font-weight:bold;color:purple;'>very good armor</span>", strength: 1*monster_level, health: 4*monster_level, agility: 1*monster_level,  level: monster_level, defence: 4*monster_level, grade: 1
    item[28] = itemname: "gloves", money: 50,name: "<span style='font-weight:bold;color:purple;'>very good gloves</span>", strength: 1*monster_level, health: 4*monster_level, agility: 2*monster_level, level: monster_level, defence: 1*monster_level, grade: 1
    item[29] = itemname: "shoes", money: 50,name: "<span style='font-weight:bold;color:purple;'>very good shoes</span>", strength: 1*monster_level, health: 3*monster_level, agility: 4*monster_level, level: monster_level, defence: 1*monster_level, grade: 1
    item[30] = itemname: "helmet",money: 50, name: "<span style='font-weight:bold;color:purple;'>very good helmet</span>", strength: 1*monster_level, health: 1*monster_level, agility: 3*monster_level,  level: monster_level, defence: 4*monster_level, grade: 1

    item[31] = itemname: "weapon",money: 500, name: "<span style='font-weight:bold;color:red;'>super good weapon</span>", strength: 5*monster_level, health: 5*monster_level, agility: 1*monster_level, level: monster_level, defence: 1*monster_level, grade: 1
    item[32] = itemname: "armor", money: 300,name: "<span style='font-weight:bold;color:red;'>super good armor</span>", strength: 2*monster_level, health: 5*monster_level, agility: 2*monster_level,  level: monster_level, defence: 5*monster_level, grade: 1
    item[33] = itemname: "gloves",money: 150, name: "<span style='font-weight:bold;color:red;'>super good gloves</span>", strength: 1*monster_level, health: 5*monster_level, agility: 3*monster_level, level: monster_level, defence: 2*monster_level, grade: 1
    item[34] = itemname: "shoes", money: 150,name: "<span style='font-weight:bold;color:red;'>super good shoes</span>", strength: 1*monster_level, health: 4*monster_level, agility: 5*monster_level,  level: monster_level, defence: 2*monster_level, grade: 1
    item[35] = itemname: "helmet", money: 150,name: "<span style='font-weight:bold;color:red;'>super good helmet</span>", strength: 1*monster_level, health: 2*monster_level, agility: 4*monster_level, level: monster_level, defence: 5*monster_level, grade: 1

    item[36] = itemname: "weapon",money: 1500, name: "<span style='font-weight:bold;color:#ec27e5;'>insane weapon</span>", strength: 6*monster_level, health: 6*monster_level, agility: 2*monster_level, level: monster_level, defence: 2*monster_level, grade: 1
    item[37] = itemname: "armor",money: 1000, name: "<span style='font-weight:bold;color:#ec27e5;'>insane armor</span>", strength: 3*monster_level, health: 6*monster_level, agility: 2*monster_level,level: monster_level, defence: 6*monster_level, grade: 1
    item[38] = itemname: "gloves",money: 500, name: "<span style='font-weight:bold;color:#ec27e5;'>insane gloves</span>", strength: 2*monster_level, health: 6*monster_level, agility: 4*monster_level,level: monster_level, defence: 3*monster_level, grade: 1
    item[39] = itemname: "shoes",money: 500, name: "<span style='font-weight:bold;color:#ec27e5;'>insane shoes</span>", strength: 2*monster_level, health: 5*monster_level, agility: 6*monster_level,  level: monster_level, defence: 3*monster_level, grade: 1
    item[40] = itemname: "helmet",money: 500, name: "<span style='font-weight:bold;color:#ec27e5;'>insane helmet</span>", strength: 2*monster_level, health: 3*monster_level, agility: 5*monster_level,level: monster_level, defence: 6*monster_level, grade: 1

    item[41] = itemname: "weapon",money: 3000, name: "<span style='font-weight:bold;color:orange;'>super insane weapon</span>", strength: 7*monster_level, health: 7*monster_level, agility: 3*monster_level,level: monster_level, defence: 3*monster_level, grade: 1
    item[42] = itemname: "armor",money: 2000, name: "<span style='font-weight:bold;color:orange;'>super insane armor</span>", strength: 4*monster_level, health: 7*monster_level, agility: 3*monster_level,level: monster_level, defence: 7*monster_level, grade: 1
    item[43] = itemname: "gloves", money: 1000,name: "<span style='font-weight:bold;color:orange;'>super insane gloves</span>", strength: 3*monster_level, health: 7*monster_level, agility: 5*monster_level,level: monster_level, defence: 4*monster_level, grade: 1
    item[44] = itemname: "shoes",money: 1000, name: "<span style='font-weight:bold;color:orange;'>super insane shoes</span>", strength: 3*monster_level, health: 6*monster_level, agility: 7*monster_level, level: monster_level, defence: 4*monster_level, grade: 1
    item[45] = itemname: "helmet",money: 1000, name: "<span style='font-weight:bold;color:orange;'>super insane helmet</span>", strength: 3*monster_level, health: 4*monster_level, agility: 6*monster_level, level: monster_level, defence: 7*monster_level, grade: 1

    bad_item = randomInt(1,11-parseInt(monster_rang))
    if bad_item > 5
      bad_item_dropped = randomInt(1,5)
      if bad_item_dropped is 1
        found_item = item[11]
      if bad_item_dropped is 2
        found_item = item[12]
      if bad_item_dropped is 3
        found_item = item[13]
      if bad_item_dropped is 4
        found_item = item[14]
      if bad_item_dropped is 5
        found_item = item[15]
    if bad_item <= 5
      normal_item_dropped = randomInt(1,6)
      if normal_item_dropped is 1
        found_item = item[16]
      if normal_item_dropped is 2
        found_item = item[17]
      if normal_item_dropped is 3
        found_item = item[18]
      if normal_item_dropped is 4
        found_item = item[19]
      if normal_item_dropped is 5
        found_item = item[20]
      if normal_item_dropped is 6
        good_item_dropped = randomInt(1,6)
        if good_item_dropped is 1
          found_item = item[21]
        if good_item_dropped is 2
          found_item = item[22]
        if good_item_dropped is 3
          found_item = item[23]
        if good_item_dropped is 4
          found_item = item[24]
        if good_item_dropped is 5
          found_item = item[25]
        if good_item_dropped is 6
          very_good_item_dropped = randomInt(1,6)
          if very_good_item_dropped is 1
            found_item = item[26]
          if very_good_item_dropped is 2
            found_item = item[27]
          if very_good_item_dropped is 3
            found_item = item[28]
          if very_good_item_dropped is 4
            found_item = item[29]
          if very_good_item_dropped is 5
            found_item = item[30]
          if very_good_item_dropped is 6
            super_good_item_dropped = randomInt(1,6)
            if super_good_item_dropped is 1
              found_item = item[31]
            if super_good_item_dropped is 2
              found_item = item[32]
            if super_good_item_dropped is 3
              found_item = item[33]
            if super_good_item_dropped is 4
              found_item = item[34]
            if super_good_item_dropped is 5
              found_item = item[35]
            if super_good_item_dropped is 6
              insane_item_dropped = randomInt(1,6)
              if insane_item_dropped is 1
                found_item = item[36]
              if insane_item_dropped is 2
                found_item = item[37]
              if insane_item_dropped is 3
                found_item = item[38]
              if insane_item_dropped is 4
                found_item = item[39]
              if insane_item_dropped is 5
                found_item = item[40]
              if insane_item_dropped is 6
                super_insane_item_dropped = randomInt(1,5)
                if super_insane_item_dropped is 1
                  found_item = item[41]
                if super_insane_item_dropped is 2
                  found_item = item[42]
                if super_insane_item_dropped is 3
                  found_item = item[43]
                if super_insane_item_dropped is 4
                  found_item = item[44]
                if super_insane_item_dropped is 5
                  found_item = item[45]
    router.send_item_to_inventory(found_item)


    

  upgrade_weapon: (e) ->
    if @model.attributes.weapon_itemname?
      price = @model.attributes.weapon_level*@model.attributes.weapon_grade*@model.attributes.weapon_grade*100
      moneymoney = parseInt(@model.attributes.money)-parseInt(price)
      if @model.attributes.money >= price and @model.attributes.weapon_grade<10
        a = @model.attributes
        @model.set(weapon_strength: a.weapon_strength+1+parseInt(a.weapon_level/10), weapon_health: a.weapon_health+1+parseInt(a.weapon_level/10), weapon_agility: a.weapon_agility+parseInt(a.weapon_level/10), weapon_defence: a.weapon_defence+parseInt(a.weapon_level/10), money: moneymoney, weapon_money: a.weapon_money+parseInt(a.weapon_grade*a.weapon_level), weapon_grade: a.weapon_grade+1)
        @model.save()
        @model.set_totals()

  upgrade_armor: (e) ->
    if @model.attributes.armor_itemname?
      price = @model.attributes.armor_level*@model.attributes.armor_grade*@model.attributes.armor_grade*100
      moneymoney = parseInt(@model.attributes.money)-parseInt(price)
      if @model.attributes.money >= price and @model.attributes.armor_grade<10
        a = @model.attributes
        @model.set(armor_strength: a.armor_strength+parseInt(a.armor_level/10), armor_health: a.armor_health+1+parseInt(a.armor_level/10), armor_agility: a.armor_agility+parseInt(a.armor_level/10), armor_defence: a.armor_defence+1+parseInt(a.armor_level/10), money: moneymoney, armor_money: a.armor_money+parseInt(a.armor_grade*a.armor_level), armor_grade: a.armor_grade+1)
        @model.save()
        @model.set_totals()

  upgrade_gloves: (e) ->
    if @model.attributes.gloves_itemname?
      price = @model.attributes.gloves_level*@model.attributes.gloves_grade*@model.attributes.gloves_grade*100
      moneymoney = parseInt(@model.attributes.money)-parseInt(price)
      if @model.attributes.money >= price and @model.attributes.gloves_grade<10
        a = @model.attributes
        @model.set(gloves_strength: a.gloves_strength+parseInt(a.gloves_level/10), gloves_health: a.gloves_health+1+parseInt(a.gloves_level/10), gloves_agility: a.gloves_agility+parseInt(a.gloves_level/10), gloves_defence: a.gloves_defence+1+parseInt(a.gloves_level/10), money: moneymoney, gloves_money: a.gloves_money+parseInt(a.gloves_grade*a.gloves_level), gloves_grade: a.gloves_grade+1)
        @model.save()
        @model.set_totals()

  upgrade_shoes: (e) ->
    if @model.attributes.shoes_itemname?
      price = @model.attributes.shoes_level*@model.attributes.shoes_grade*@model.attributes.shoes_grade*100
      moneymoney = parseInt(@model.attributes.money)-parseInt(price)
      if @model.attributes.money >= price and @model.attributes.shoes_grade<10
        a = @model.attributes
        @model.set(shoes_strength: a.shoes_strength+parseInt(a.shoes_level/10), shoes_health: a.shoes_health+1+parseInt(a.shoes_level/10), shoes_agility: a.shoes_agility+1+parseInt(a.shoes_level/10), shoes_defence: a.shoes_defence+parseInt(a.shoes_level/10), money: moneymoney, shoes_money: a.shoes_money+parseInt(a.shoes_grade*a.shoes_level), shoes_grade: a.shoes_grade+1)
        @model.save()
        @model.set_totals()

  upgrade_helmet: (e) ->
    if @model.attributes.helmet_itemname?
      price = @model.attributes.helmet_level*@model.attributes.helmet_grade*@model.attributes.helmet_grade*100
      moneymoney = parseInt(@model.attributes.money)-parseInt(price)
      if @model.attributes.money >= price and @model.attributes.helmet_grade<10
        a = @model.attributes
        @model.set(helmet_strength: a.helmet_strength+parseInt(a.helmet_level/10), helmet_health: a.helmet_health+parseInt(a.helmet_level/10), helmet_agility: a.helmet_agility+1+parseInt(a.helmet_level/10), helmet_defence: a.helmet_defence+1+parseInt(a.helmet_level/10), money: moneymoney, helmet_money: a.helmet_money+parseInt(a.helmet_grade*a.helmet_level), helmet_grade: a.helmet_grade+1)
        @model.save()
        @model.set_totals()
    
  remove_weapon: (e) ->
    if @model.attributes.weapon_itemname?
      attributes1 = []
      attributes1[0] = itemname: @model.attributes.weapon_itemname, money: @model.attributes.weapon_money, name: @model.attributes.weapon_name, strength: @model.attributes.weapon_strength, health: @model.attributes.weapon_health, agility: @model.attributes.weapon_agility,  level: @model.attributes.weapon_level, defence: @model.attributes.weapon_defence, user_id: @model.attributes.weapon_user_id, grade: @model.attributes.weapon_grade
      router.send_item_to_inventory(attributes1[0])
      @model.set(weapon_itemname: null, weapon_money: 0, weapon_name: null, weapon_strength: 0, weapon_health: 0, weapon_agility: 0,  weapon_level: 0, weapon_defence: 0, weapon_user_id: 0, weapon_grade:1)
      @model.save()
      @model.set_totals()

  remove_armor: (e) ->
    if @model.attributes.armor_itemname?
      attributes1 = []
      attributes1[0] = itemname: @model.attributes.armor_itemname, money: @model.attributes.armor_money, name: @model.attributes.armor_name, strength: @model.attributes.armor_strength, health: @model.attributes.armor_health, agility: @model.attributes.armor_agility,  level: @model.attributes.armor_level, defence: @model.attributes.armor_defence, user_id: @model.attributes.armor_user_id, grade: @model.attributes.armor_grade
      router.send_item_to_inventory(attributes1[0])
      @model.set(armor_itemname: null, armor_money: 0, armor_name: null, armor_strength: 0, armor_health: 0, armor_agility: 0,  armor_level: 0, armor_defence: 0, armor_user_id: 0, armor_grade: 1)
      @model.save()
      @model.set_totals()

  remove_gloves: (e) ->
    if @model.attributes.gloves_itemname?
      attributes1 = []
      attributes1[0] = itemname: @model.attributes.gloves_itemname, money: @model.attributes.gloves_money, name: @model.attributes.gloves_name, strength: @model.attributes.gloves_strength, health: @model.attributes.gloves_health, agility: @model.attributes.gloves_agility,  level: @model.attributes.gloves_level, defence: @model.attributes.gloves_defence, user_id: @model.attributes.gloves_user_id, grade: @model.attributes.gloves_grade
      router.send_item_to_inventory(attributes1[0])
      @model.set(gloves_itemname: null, gloves_money: 0, gloves_name: null, gloves_strength: 0, gloves_health: 0, gloves_agility: 0,  gloves_level: 0, gloves_defence: 0, gloves_user_id: 0, gloves_grade:1)
      @model.save()
      @model.set_totals()

  remove_shoes: (e) ->
    if @model.attributes.shoes_itemname?
      attributes1 = []
      attributes1[0] = itemname: @model.attributes.shoes_itemname, money: @model.attributes.shoes_money, name: @model.attributes.shoes_name, strength: @model.attributes.shoes_strength, health: @model.attributes.shoes_health, agility: @model.attributes.shoes_agility,  level: @model.attributes.shoes_level, defence: @model.attributes.shoes_defence, user_id: @model.attributes.shoes_user_id, grade: @model.attributes.shoes_grade
      router.send_item_to_inventory(attributes1[0])
      @model.set(shoes_itemname: null, shoes_money: 0, shoes_name: null, shoes_strength: 0, shoes_health: 0, shoes_agility: 0,  shoes_level: 0, shoes_defence: 0, shoes_user_id: 0, shoes_grade: 1)
      @model.save()
      @model.set_totals()

  remove_helmet: (e) ->
    if @model.attributes.helmet_itemname?
      attributes1 = []
      attributes1[0] = itemname: @model.attributes.helmet_itemname, money: @model.attributes.helmet_money, name: @model.attributes.helmet_name, strength: @model.attributes.helmet_strength, health: @model.attributes.helmet_health, agility: @model.attributes.helmet_agility,  level: @model.attributes.helmet_level, defence: @model.attributes.helmet_defence, user_id: @model.attributes.helmet_user_id, grade: @model.attributes.helmet_grade
      router.send_item_to_inventory(attributes1[0])
      @model.set(helmet_itemname: null, helmet_money: 0, helmet_name: null, helmet_strength: 0, helmet_health: 0, helmet_agility: 0,  helmet_level: 0, helmet_defence: 0, helmet_user_id: 0, helmet_grade: 1)
      @model.save()
      @model.set_totals()

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
