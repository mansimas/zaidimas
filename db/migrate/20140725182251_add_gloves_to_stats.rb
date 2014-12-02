class AddGlovesToStats < ActiveRecord::Migration
  def change
    add_column :stats, :gloves_name, :text
    add_column :stats, :gloves_user_id, :integer
    add_column :stats, :gloves_strength, :integer
    add_column :stats, :gloves_health, :integer
    add_column :stats, :gloves_agility, :integer
    add_column :stats, :gloves_level, :integer
    add_column :stats, :gloves_defence, :integer
  end
end
