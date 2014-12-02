class AddMorestatsToStats < ActiveRecord::Migration
  def change
    add_column :stats, :monster_hp, :integer
    add_column :stats, :player_hp, :integer
    add_column :stats, :max_hp, :integer
    add_column :stats, :monster_name, :string
    add_column :stats, :monster_strength, :integer
  end
end
