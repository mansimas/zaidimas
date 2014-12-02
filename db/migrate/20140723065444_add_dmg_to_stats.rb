class AddDmgToStats < ActiveRecord::Migration
  def change
    add_column :stats, :min_dmg, :integer
    add_column :stats, :max_dmg, :integer
    add_column :stats, :speed, :integer
    add_column :stats, :agility, :integer
    add_column :stats, :monster_min_dmg, :integer
    add_column :stats, :monster_max_dmg, :integer
    add_column :stats, :monster_speed, :integer
    add_column :stats, :monster_agility, :integer
    add_column :stats, :defence, :integer
    add_column :stats, :monster_defence, :integer
  end
end
