class AddArmorsToStats < ActiveRecord::Migration
  def change
    add_column :stats, :armor_name, :text
    add_column :stats, :armor_user_id, :integer
    add_column :stats, :armor_strength, :integer
    add_column :stats, :armor_health, :integer
    add_column :stats, :armor_agility, :integer
    add_column :stats, :armor_level, :integer
    add_column :stats, :armor_defence, :integer
  end
end
