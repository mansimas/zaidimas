class Sprint.Routers.DropsRouter extends Backbone.Router
  initialize: (options) ->
    @items = new Sprint.Collections.ItemsCollection()
    @items.reset options.items
    @stats = new Sprint.Collections.StatsCollection()
    @stats.reset options.stats
    @inventories = new Sprint.Collections.InventoriesCollection()
    @inventories.reset options.inventories
    @shops = new Sprint.Collections.ShopsCollection()
    @shops.reset options.shops
    @chats = new Sprint.Collections.ChatsCollection()
    @chats.reset options.chats
    @monsters = new Sprint.Collections.MonstersCollection()
    @monsters.reset options.monsters

  routes:
    "index"                : "index"
    ".*"                   : "index"
    "newMonster"           : "newMonster"
    ":id/editMonster"      : "editMonster"
    ":id/showMonster"      : "showMonster"
    ":id/showInventory"    : "showInventory"
    ":id/showItem"         : "showItem"
    ":id/showShop"         : "showShop"


  index: ->
    @view = new Sprint.Views.Items.IndexView(items: @items)
    $("#items").html(@view.render().el)
    @view = new Sprint.Views.Stats.IndexView(stats: @stats)
    $("#stats").html(@view.render().el)
    @view = new Sprint.Views.Stats.extra_IndexView(stats: @stats)
    $("#stats_extra").html(@view.render().el)
    @view = new Sprint.Views.Monsters.IndexView(monsters: @monsters)
    $("#monsters").html(@view.render().el)
    @view = new Sprint.Views.Maps.IndexView(monsters: @monsters)
    #$("#maps").html(@view.render().el)

    @view = new Sprint.Views.Inventories.IndexView(inventories: @inventories)
    $("#inventories").html(@view.render().el)
    @view = new Sprint.Views.Shops.IndexView(shops: @shops)
    $("#shops").html(@view.render().el)
    @view = new Sprint.Views.Chats.IndexView(chats: @chats)
    $("#chats").html(@view.render().el)

  showMonster: (id) ->
    monster = @monsters.get(id)
    @view = new Sprint.Views.Monsters.ShowView(model: monster)
    $("#monsters").html(@view.render().el)

  showInventory: (id) ->
    inventory = @inventories.get(id)
    @view = new Sprint.Views.Inventories.ShowView(model: inventory)
    $("#inventories").html(@view.render().el)

  showShop: (id) ->
    shop = @shops.get(id)
    @view = new Sprint.Views.Shops.ShowView(model: shop)
    $("#shops").html(@view.render().el)

  showItem: (id) ->
    item = @items.get(id)
    @view = new Sprint.Views.Items.ShowView(model: item)
    $("#items").html(@view.render().el)

  editMonster: (id) ->
    monster = @monsters.get(id)
    @view = new Sprint.Views.Monsters.EditView(model: monster)
    $("#monsters").html(@view.render().el)


##########################  Functions  #####################################

  set_attack_allowed: () ->
    @view = new Sprint.Views.Maps.IndexView(monsters: @monsters)
    @view.set_attack_allowed()

  send_maps_to_monsters: (attributes) ->
    @view = new Sprint.Views.Monsters.IndexView(monsters: @monsters)
    @view.send_monster_to_monsters(attributes)
   
  create_new_monster: (level, rang=1) ->
    @view = new Sprint.Views.Monsters.IndexView(monsters: @monsters)
    @view.create_new_monster(level, rang)

  sell_item: (attributes) ->
    @view = new Sprint.Views.Stats.IndexView(stats: @stats)
    @view.sell_item(attributes)

  buy_item: (attributes) ->
    @view = new Sprint.Views.Stats.IndexView(stats: @stats)
    @view.buy_item(attributes)

  use_this_item: (attributes) ->
    @view = new Sprint.Views.Stats.IndexView(stats: @stats)
    @view.use_this_item(attributes)

  shop_this_item: (attributes) ->
    @view = new Sprint.Views.Shops.IndexView(shops: @shops)
    @view.shop_this_item(attributes)

  send_monster_to_root: (attributes) ->
    @view = new Sprint.Views.Stats.IndexView(stats: @stats)
    @view.send_monster_to_player(attributes)

  send_item_to_inventory: (attributes) ->
    @view = new Sprint.Views.Inventories.IndexView(inventories: @inventories)
    @view.create_item(attributes)

  bought_item: (attributes) ->
    @view = new Sprint.Views.Inventories.IndexView(inventories: @inventories)
    @view.bought_item(attributes)

  newMonster: ->
    @view = new Sprint.Views.Monsters.NewView(collection: @monsters)
    $("#monsters").html(@view.render().el)
    
  render_maps: ->
    @view = new Sprint.Views.Maps.IndexView(model: myRectangle)
    @view.rerender()