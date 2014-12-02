class Sprint.Models.Stat extends Backbone.Model
  paramRoot: 'stat'
  
  set_dmg: ->
    @set(min_dmg: @attributes.total_strength, max_dmg: @attributes.total_strength*2)
    @save()

  set_totals: ->
    @set( 																												\
    total_health: 																									\
    		@attributes.health+@attributes.weapon_health+@attributes.armor_health+ 					\
    		@attributes.gloves_health+@attributes.shoes_health+@attributes.helmet_health,
    total_strength:  																								\
    		@attributes.strength+@attributes.weapon_strength+@attributes.armor_strength+ 			\
    		@attributes.gloves_strength+@attributes.shoes_strength+@attributes.helmet_strength,
    total_agility:  																									\
    		@attributes.agility+@attributes.weapon_agility+@attributes.armor_agility+			 	\
    		@attributes.gloves_agility+@attributes.shoes_agility+@attributes.helmet_agility,
    total_defence:  																									\
    		@attributes.defence+@attributes.weapon_defence+@attributes.armor_defence+ 				\
    		@attributes.gloves_defence+@attributes.shoes_defence+@attributes.helmet_defence,
    speed:  																											\
    		1000+parseInt(@attributes.total_agility/3),
    critical:  																										\
    		10+parseInt(@attributes.total_agility/50),
    critical_multiplier: 																							\
    		2+parseInt(@attributes.total_agility/500)
    )
    @save()
    @set_dmg()
    @set_max_hp()
    
  set_max_hp: ->
    @set(max_hp: @attributes.total_health*10)
    @save()
    @check_attributes()
    
  check_attributes: ->
    if @attributes.player_hp > @attributes.max_hp
      @set(player_hp: @attributes.max_hp)
    if @attributes.player_hp < 0
      @set(player_hp: 0)
    @save()
    
    













class Sprint.Collections.StatsCollection extends Backbone.Collection
  model: Sprint.Models.Stat
  url: '/stats'


