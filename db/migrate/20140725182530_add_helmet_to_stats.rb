class AddHelmetToStats < ActiveRecord::Migration
  def change
    add_column :stats, :helmet_name, :text
    add_column :stats, :helmet_user_id, :integer
    add_column :stats, :helmet_strength, :integer
    add_column :stats, :helmet_health, :integer
    add_column :stats, :helmet_agility, :integer
    add_column :stats, :helmet_level, :integer
    add_column :stats, :helmet_defence, :integer
  end
end
