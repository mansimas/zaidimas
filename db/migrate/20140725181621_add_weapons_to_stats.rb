class AddWeaponsToStats < ActiveRecord::Migration
  def change
    add_column :stats, :weapon_name, :text
    add_column :stats, :weapon_user_id, :integer
    add_column :stats, :weapon_strength, :integer
    add_column :stats, :weapon_health, :integer
    add_column :stats, :weapon_agility, :integer
    add_column :stats, :weapon_level, :integer
    add_column :stats, :weapon_defence, :integer
  end
end
