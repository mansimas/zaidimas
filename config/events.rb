WebsocketRails::EventMap.describe do
  subscribe :player_attacks_enemy, :to => HardWorker, :with_method => :player_attacks_enemy
  subscribe :player_killed_enemy, :to => HardWorker, :with_method => :player_killed_enemy
end
